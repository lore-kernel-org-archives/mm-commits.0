From: akpm@linux-foundation.org
Subject: + lguest-documentatation-and-example-launcher.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:39 -0800
Message-ID: <200702130703.l1D73dHj024568@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57032 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbXBMHDw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     lguest: documentatation and example launcher
has been added to the -mm tree.  Its filename is
     lguest-documentatation-and-example-launcher.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: documentatation and example launcher
From: Rusty Russell <rusty@rustcorp.com.au>

Fairly complete documentation for lguest.  I actually want to get rid of the
"coding" part of lguest.txt and roll it into the code itself,
literary-programming-style.

The launcher utility is also here: I don't have delusions of interface
stability, so it makes sense to have it here as an example, and it's only 1000
lines.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dontdiff          |    3 
 Documentation/lguest/Makefile   |   21 
 Documentation/lguest/lguest.c   |  989 ++++++++++++++++++++++++++++++
 Documentation/lguest/lguest.txt |  355 ++++++++++
 4 files changed, 1368 insertions(+)

diff -puN Documentation/dontdiff~lguest-documentatation-and-example-launcher Documentation/dontdiff
--- a/Documentation/dontdiff~lguest-documentatation-and-example-launcher
+++ a/Documentation/dontdiff
@@ -144,3 +144,6 @@ vsyscall.lds
 wanxlfw.inc
 uImage
 zImage
+hypervisor-blob.c
+lguest.lds
+hypervisor-raw
diff -puN /dev/null Documentation/lguest/Makefile
--- /dev/null
+++ a/Documentation/lguest/Makefile
@@ -0,0 +1,21 @@
+# This creates the demonstration utility "lguest" which runs a Linux guest.
+
+# We rely on CONFIG_PAGE_OFFSET to know where to put lguest binary.
+# Some shells (dash - ubunu) can't handle numbers that big so we cheat.
+include ../../.config
+LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)
+
+CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 \
+	-static -DLGUEST_GUEST_TOP="$(LGUEST_GUEST_TOP)" -Wl,-T,lguest.lds
+LDLIBS:=-lz
+
+all: lguest.lds lguest
+
+# The linker script on x86 is so complex the only way of creating one
+# which will link our binary in the right place is to mangle the
+# default one.
+lguest.lds:
+	$(LD) --verbose | awk '/^==========/ { PRINT=1; next; } /SIZEOF_HEADERS/ { gsub(/0x[0-9A-F]*/, "$(LGUEST_GUEST_TOP)") } { if (PRINT) print $$0; }' > $@
+
+clean:
+	rm -f lguest.lds lguest
diff -puN /dev/null Documentation/lguest/lguest.c
--- /dev/null
+++ a/Documentation/lguest/lguest.c
@@ -0,0 +1,989 @@
+/* Simple program to layout "physical" memory for new lguest guest.
+ * Linked high to avoid likely physical memory.  */
+#define _LARGEFILE64_SOURCE
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <err.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <elf.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <fcntl.h>
+#include <assert.h>
+#include <stdbool.h>
+#include <errno.h>
+#include <signal.h>
+#include <sys/socket.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+#include <time.h>
+#include <netinet/in.h>
+#include <linux/if.h>
+#include <linux/if_tun.h>
+#include <sys/uio.h>
+#include <termios.h>
+#include <zlib.h>
+typedef uint32_t u32;
+typedef uint16_t u16;
+typedef uint8_t u8;
+
+#include "../../include/asm/lguest_user.h"
+
+#define PAGE_PRESENT 0x7 	/* Present, RW, Execute */
+#define NET_PEERNUM 1
+
+static bool verbose;
+#define verbose(args...) \
+	do { if (verbose) printf(args); fflush(stdout); } while(0)
+
+struct devices
+{
+	fd_set infds;
+	int max_infd;
+
+	struct device *dev;
+};
+
+struct device
+{
+	struct device *next;
+	struct lguest_device_desc *desc;
+	void *mem;
+
+	/* Watch this fd if handle_input non-NULL. */
+	int fd;
+	int (*handle_input)(int fd, struct device *me);
+
+	/* Watch DMA to this address if handle_input non-NULL. */
+	unsigned long watch_address;
+	u32 (*handle_output)(int fd, const struct iovec *iov,
+			     unsigned int num, struct device *me);
+
+	/* Device-specific data. */
+	void *priv;
+};
+
+static char buf[1024];
+static struct iovec discard_iov = { .iov_base=buf, .iov_len=sizeof(buf) };
+static int zero_fd;
+
+static u32 memparse(const char *ptr)
+{
+	char *end;
+	unsigned long ret = strtoul(ptr, &end, 0);
+
+	switch (*end) {
+	case 'G':
+	case 'g':
+		ret <<= 10;
+	case 'M':
+	case 'm':
+		ret <<= 10;
+	case 'K':
+	case 'k':
+		ret <<= 10;
+		end++;
+	default:
+		break;
+	}
+	return ret;
+}
+
+static inline unsigned long page_align(unsigned long addr)
+{
+	return ((addr + getpagesize()-1) & ~(getpagesize()-1));
+}
+
+/* initrd gets loaded at top of memory: return length. */
+static unsigned long load_initrd(const char *name, unsigned long end)
+{
+	int ifd;
+	struct stat st;
+	void *iaddr;
+
+	if (!name)
+		return 0;
+
+	ifd = open(name, O_RDONLY, 0);
+	if (ifd < 0)
+		err(1, "Opening initrd '%s'", name);
+
+	if (fstat(ifd, &st) < 0)
+		err(1, "fstat() on initrd '%s'", name);
+
+	iaddr = mmap((void *)end - st.st_size, st.st_size,
+		     PROT_READ|PROT_EXEC|PROT_WRITE,
+		     MAP_FIXED|MAP_PRIVATE, ifd, 0);
+	if (iaddr != (void *)end - st.st_size)
+		err(1, "Mmaping initrd '%s' returned %p not %p",
+		    name, iaddr, (void *)end - st.st_size);
+	close(ifd);
+	verbose("mapped initrd %s size=%lu @ %p\n", name, st.st_size, iaddr);
+	return st.st_size;
+}
+
+/* First map /dev/zero over entire memory, then insert kernel. */
+static void map_memory(unsigned long mem)
+{
+	if (mmap(0, mem,
+		 PROT_READ|PROT_WRITE|PROT_EXEC,
+		 MAP_FIXED|MAP_PRIVATE, zero_fd, 0) != (void *)0)
+		err(1, "Mmaping /dev/zero for %li bytes", mem);
+}
+
+static u32 finish(unsigned long mem, unsigned long *page_offset,
+		  const char *initrd, unsigned long *ird_size)
+{
+	u32 *pgdir = NULL, *linear = NULL;
+	int i, pte_pages;
+
+	/* This is a top of mem. */
+	*ird_size = load_initrd(initrd, mem);
+
+	/* Below initrd is used as top level of pagetable. */
+	pte_pages = 1 + (mem/getpagesize() + 1023)/1024;
+
+	pgdir = (u32 *)page_align(mem - *ird_size - pte_pages*getpagesize());
+	linear = (void *)pgdir + getpagesize();
+
+	/* Linear map all of memory at page_offset (to top of mem). */
+	if (mem > -*page_offset)
+		mem = -*page_offset;
+
+	for (i = 0; i < mem / getpagesize(); i++)
+		linear[i] = ((i * getpagesize()) | PAGE_PRESENT);
+	verbose("Linear %p-%p (%i-%i) = %#08x-%#08x\n",
+		linear, linear+i-1, 0, i-1, linear[0], linear[i-1]);
+
+	/* Now set up pgd so that this memory is at page_offset */
+	for (i = 0; i < mem / getpagesize(); i += getpagesize()/sizeof(u32)) {
+		pgdir[(i + *page_offset/getpagesize())/1024]
+			= (((u32)linear + i*sizeof(u32)) | PAGE_PRESENT);
+		verbose("Top level %lu = %#08x\n",
+			(i + *page_offset/getpagesize())/1024,
+			pgdir[(i + *page_offset/getpagesize())/1024]);
+	}
+
+	return (unsigned long)pgdir;
+}
+
+/* Returns the entry point */
+static u32 map_elf(int elf_fd, const Elf32_Ehdr *ehdr, unsigned long mem,
+		   unsigned long *pgdir_addr,
+		   const char *initrd, unsigned long *ird_size,
+		   unsigned long *page_offset)
+{
+	void *addr;
+	Elf32_Phdr phdr[ehdr->e_phnum];
+	unsigned int i;
+
+	/* Sanity checks. */
+	if (ehdr->e_type != ET_EXEC
+	    || ehdr->e_machine != EM_386
+	    || ehdr->e_phentsize != sizeof(Elf32_Phdr)
+	    || ehdr->e_phnum < 1 || ehdr->e_phnum > 65536U/sizeof(Elf32_Phdr))
+		errx(1, "Malformed elf header");
+
+	if (lseek(elf_fd, ehdr->e_phoff, SEEK_SET) < 0)
+		err(1, "Seeking to program headers");
+	if (read(elf_fd, phdr, sizeof(phdr)) != sizeof(phdr))
+		err(1, "Reading program headers");
+
+	map_memory(mem);
+
+	*page_offset = 0;
+	/* We map the loadable segments at virtual addresses corresponding
+	 * to their physical addresses (our virtual == guest physical). */
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		if (phdr[i].p_type != PT_LOAD)
+			continue;
+
+		verbose("Section %i: size %i addr %p\n",
+			i, phdr[i].p_memsz, (void *)phdr[i].p_paddr);
+		/* We map everything private, writable. */
+		if (phdr[i].p_paddr + phdr[i].p_memsz > mem)
+			errx(1, "Segment %i overlaps end of memory", i);
+
+		/* We expect linear address space. */
+		if (!*page_offset)
+			*page_offset = phdr[i].p_vaddr - phdr[i].p_paddr;
+		else if (*page_offset != phdr[i].p_vaddr - phdr[i].p_paddr)
+			errx(1, "Page offset of section %i different", i);
+
+		/* Recent ld versions don't page align any more. */
+		if (phdr[i].p_paddr % getpagesize()) {
+			phdr[i].p_filesz += (phdr[i].p_paddr % getpagesize());
+			phdr[i].p_offset -= (phdr[i].p_paddr % getpagesize());
+			phdr[i].p_paddr -= (phdr[i].p_paddr % getpagesize());
+		}
+		addr = mmap((void *)phdr[i].p_paddr,
+			    phdr[i].p_filesz,
+			    PROT_READ|PROT_WRITE|PROT_EXEC,
+			    MAP_FIXED|MAP_PRIVATE,
+			    elf_fd, phdr[i].p_offset);
+		if (addr != (void *)phdr[i].p_paddr)
+			err(1, "Mmaping vmlinux segment %i returned %p not %p (%p)",
+			    i, addr, (void *)phdr[i].p_paddr, &phdr[i].p_paddr);
+	}
+
+	*pgdir_addr = finish(mem, page_offset, initrd, ird_size);
+	/* Entry is physical address: convert to virtual */
+	return ehdr->e_entry + *page_offset;
+}
+
+static unsigned long intuit_page_offset(unsigned char *img, unsigned long len)
+{
+	unsigned int i, possibilities[256];
+
+	for (i = 0; i + 4 < len; i++) {
+		/* mov 0xXXXXXXXX,%eax */
+		if (img[i] == 0xA1 && ++possibilities[img[i+4]] > 3)
+			return (unsigned long)img[i+4] << 24;
+	}
+	errx(1, "could not determine page offset");
+}
+
+static u32 bzimage(int fd, unsigned long mem, unsigned long *pgdir_addr,
+		   const char *initrd, unsigned long *ird_size,
+		   unsigned long *page_offset)
+{
+	gzFile f;
+	int ret, len = 0;
+	void *img = (void *)0x100000;
+
+	map_memory(mem);
+
+	f = gzdopen(fd, "rb");
+	if (gzdirect(f))
+		errx(1, "did not find correct gzip header");
+	while ((ret = gzread(f, img + len, 65536)) > 0)
+		len += ret;
+	if (ret < 0)
+		err(1, "reading image from bzImage");
+
+	verbose("Unpacked size %i addr %p\n", len, img);
+	*page_offset = intuit_page_offset(img, len);
+	*pgdir_addr = finish(mem, page_offset, initrd, ird_size);
+
+	/* Entry is physical address: convert to virtual */
+	return (u32)img + *page_offset;
+}
+
+static u32 load_bzimage(int bzimage_fd, const Elf32_Ehdr *ehdr,
+			unsigned long mem, unsigned long *pgdir_addr,
+			const char *initrd, unsigned long *ird_size,
+			unsigned long *page_offset)
+{
+	unsigned char c;
+	int state = 0;
+
+	/* Just brute force it. */
+	while (read(bzimage_fd, &c, 1) == 1) {
+		switch (state) {
+		case 0:
+			if (c == 0x1F)
+				state++;
+			break;
+		case 1:
+			if (c == 0x8B)
+				state++;
+			else
+				state = 0;
+			break;
+		case 2 ... 8:
+			state++;
+			break;
+		case 9:
+			lseek(bzimage_fd, -10, SEEK_CUR);
+			if (c != 0x03) /* Compressed under UNIX. */
+				state = -1;
+			else
+				return bzimage(bzimage_fd, mem, pgdir_addr,
+					       initrd, ird_size, page_offset);
+		}
+	}
+	errx(1, "Could not find kernel in bzImage");
+}
+
+static void *map_pages(unsigned long addr, unsigned int num)
+{
+	if (mmap((void *)addr, getpagesize() * num,
+		 PROT_READ|PROT_WRITE|PROT_EXEC,
+		 MAP_FIXED|MAP_PRIVATE, zero_fd, 0) != (void *)addr)
+		err(1, "Mmaping %u pages of /dev/zero @%p", num, (void *)addr);
+	return (void *)addr;
+}
+
+static struct lguest_device_desc *
+get_dev_entry(struct lguest_device_desc *descs, u16 type, u16 num_pages)
+{
+	static unsigned long top = LGUEST_GUEST_TOP;
+	int i;
+	unsigned long pfn = 0;
+
+	if (num_pages) {
+		top -= num_pages*getpagesize();
+		map_pages(top, num_pages);
+		pfn = top / getpagesize();
+	}
+
+	for (i = 0; i < LGUEST_MAX_DEVICES; i++) {
+		if (!descs[i].type) {
+			descs[i].features = descs[i].status = 0;
+			descs[i].type = type;
+			descs[i].num_pages = num_pages;
+			descs[i].pfn = pfn;
+			return &descs[i];
+		}
+	}
+	errx(1, "too many devices");
+}
+
+static void set_fd(int fd, struct devices *devices)
+{
+	FD_SET(fd, &devices->infds);
+	if (fd > devices->max_infd)
+		devices->max_infd = fd;
+}
+
+static struct device *new_device(struct devices *devices,
+				 struct lguest_device_desc *descs,
+				 u16 type, u16 num_pages,
+				 int fd,
+				 int (*handle_input)(int, struct device *),
+				 unsigned long watch_off,
+				 u32 (*handle_output)(int,
+						      const struct iovec *,
+						      unsigned,
+						      struct device *))
+{
+	struct device *dev = malloc(sizeof(*dev));
+
+	dev->next = devices->dev;
+	devices->dev = dev;
+
+	dev->fd = fd;
+	if (handle_input)
+		set_fd(dev->fd, devices);
+	dev->desc = get_dev_entry(descs, type, num_pages);
+	dev->mem = (void *)(dev->desc->pfn * getpagesize());
+	dev->handle_input = handle_input;
+	dev->watch_address = (unsigned long)dev->mem + watch_off;
+	dev->handle_output = handle_output;
+	return dev;
+}
+
+static int tell_kernel(u32 pagelimit, u32 pgdir, u32 start, u32 page_offset)
+{
+	u32 args[] = { LHREQ_INITIALIZE,
+		       pagelimit, pgdir, start, page_offset };
+	int fd = open("/dev/lguest", O_RDWR);
+
+	if (fd < 0)
+		err(1, "Opening /dev/lguest");
+
+	verbose("Telling kernel limit %u, pgdir %i, e=%#08x page_off=0x%08x\n",
+		pagelimit, pgdir, start, page_offset);
+	if (write(fd, args, sizeof(args)) < 0)
+		err(1, "Writing to /dev/lguest");
+	return fd;
+}
+
+static void concat(char *dst, char *args[])
+{
+	unsigned int i, len = 0;
+
+	for (i = 0; args[i]; i++) {
+		strcpy(dst+len, args[i]);
+		strcat(dst+len, " ");
+		len += strlen(args[i]) + 1;
+	}
+	/* In case it's empty. */
+	dst[len] = '\0';
+}
+
+static void *_check_pointer(unsigned long addr, unsigned int size,
+			    unsigned int line)
+{
+	if (addr >= LGUEST_GUEST_TOP || addr + size >= LGUEST_GUEST_TOP)
+		errx(1, "%s:%i: Invalid address %li", __FILE__, line, addr);
+	return (void *)addr;
+}
+#define check_pointer(addr,size) _check_pointer(addr, size, __LINE__)
+
+/* Returns pointer to dma->used_len */
+static u32 *dma2iov(unsigned long dma, struct iovec iov[], unsigned *num)
+{
+	unsigned int i;
+	struct lguest_dma *udma;
+
+	/* No buffers? */
+	if (dma == 0) {
+		printf("no buffers\n");
+		return NULL;
+	}
+
+	udma = check_pointer(dma, sizeof(*udma));
+	for (i = 0; i < LGUEST_MAX_DMA_SECTIONS; i++) {
+		if (!udma->len[i])
+			break;
+
+		iov[i].iov_base = check_pointer(udma->addr[i], udma->len[i]);
+		iov[i].iov_len = udma->len[i];
+	}
+	*num = i;
+	return &udma->used_len;
+}
+
+static u32 *get_dma_buffer(int fd, void *addr,
+			   struct iovec iov[], unsigned *num, u32 *irq)
+{
+	u32 buf[] = { LHREQ_GETDMA, (u32)addr };
+	unsigned long udma;
+	u32 *res;
+
+	udma = write(fd, buf, sizeof(buf));
+	if (udma == (unsigned long)-1)
+		return NULL;
+
+	/* Kernel stashes irq in ->used_len. */
+	res = dma2iov(udma, iov, num);
+	if (res)
+		*irq = *res;
+	return res;
+}
+
+static void trigger_irq(int fd, u32 irq)
+{
+	u32 buf[] = { LHREQ_IRQ, irq };
+	if (write(fd, buf, sizeof(buf)) != 0)
+		err(1, "Triggering irq %i", irq);
+}
+
+static struct termios orig_term;
+static void restore_term(void)
+{
+	tcsetattr(STDIN_FILENO, TCSANOW, &orig_term);
+}
+
+struct console_abort
+{
+	int count;
+	struct timeval start;
+};
+
+/* We DMA input to buffer bound at start of console page. */
+static int handle_console_input(int fd, struct device *dev)
+{
+	u32 num, irq = 0, *lenp;
+	int len;
+	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
+	struct console_abort *abort = dev->priv;
+
+	lenp = get_dma_buffer(fd, dev->mem, iov, &num, &irq);
+	if (!lenp) {
+		warn("console: no dma buffer!");
+		iov[0] = discard_iov;
+		num = 1;
+	}
+
+	len = readv(dev->fd, iov, num);
+	if (len <= 0) {
+		warnx("Failed to get console input, ignoring console.");
+		len = 0;
+	}
+
+	if (lenp) {
+		*lenp = len;
+		trigger_irq(fd, irq);
+	}
+
+	/* Three ^C within one second?  Exit. */
+	if (len == 1 && ((char *)iov[0].iov_base)[0] == 3) {
+		if (!abort->count++)
+			gettimeofday(&abort->start, NULL);
+		else if (abort->count == 3) {
+			struct timeval now;
+			gettimeofday(&now, NULL);
+			if (now.tv_sec <= abort->start.tv_sec+1)
+				exit(2);
+			abort->count = 0;
+		}
+	} else
+		abort->count = 0;
+
+	if (!len) {
+		restore_term();
+		return 0;
+	}
+	return 1;
+}
+
+static unsigned long peer_offset(unsigned int peernum)
+{
+	return 4 * peernum;
+}
+
+static u32 handle_tun_output(int fd, const struct iovec *iov,
+			     unsigned num, struct device *dev)
+{
+	/* Now we've seen output, we should warn if we can't get buffers. */
+	*(bool *)dev->priv = true;
+	return writev(dev->fd, iov, num);
+}
+
+static u32 handle_block_output(int fd, const struct iovec *iov,
+			       unsigned num, struct device *dev)
+{
+	struct lguest_block_page *p = dev->mem;
+	u32 irq, reply_num, *lenp;
+	int len;
+	struct iovec reply[LGUEST_MAX_DMA_SECTIONS];
+	off64_t device_len, off = (off64_t)p->sector * 512;
+
+	device_len = *(off64_t *)dev->priv;
+
+	if (off >= device_len)
+		err(1, "Bad offset %llu vs %llu", off, device_len);
+	if (lseek64(dev->fd, off, SEEK_SET) != off)
+		err(1, "Bad seek to sector %i", p->sector);
+
+	verbose("Block: %s at offset %llu\n", p->type ? "WRITE" : "READ", off);
+
+	lenp = get_dma_buffer(fd, dev->mem, reply, &reply_num, &irq);
+	if (!lenp)
+		err(1, "Block request didn't give us a dma buffer");
+
+	if (p->type) {
+		len = writev(dev->fd, iov, num);
+		if (off + len > device_len) {
+			ftruncate(dev->fd, device_len);
+			errx(1, "Write past end %llu+%u", off, len);
+		}
+		*lenp = 0;
+	} else {
+		len = readv(dev->fd, reply, reply_num);
+		*lenp = len;
+	}
+
+	p->result = 1 + (p->bytes != len);
+	trigger_irq(fd, irq);
+	return 0;
+}
+
+#define HIPQUAD(ip)				\
+	((u8)(ip >> 24)),			\
+	((u8)(ip >> 16)),			\
+	((u8)(ip >> 8)),			\
+	((u8)(ip))
+
+static void configure_device(const char *devname, u32 ipaddr,
+			     unsigned char hwaddr[6])
+{
+	struct ifreq ifr;
+	int fd;
+	struct sockaddr_in *sin = (struct sockaddr_in *)&ifr.ifr_addr;
+
+	memset(&ifr, 0, sizeof(ifr));
+	strcpy(ifr.ifr_name, devname);
+	sin->sin_family = AF_INET;
+	sin->sin_addr.s_addr = htonl(ipaddr);
+	fd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
+	if (fd < 0)
+		err(1, "opening IP socket");
+	if (ioctl(fd, SIOCSIFADDR, &ifr) != 0)
+		err(1, "Setting %s interface address", devname);
+	ifr.ifr_flags = IFF_UP;
+	if (ioctl(fd, SIOCSIFFLAGS, &ifr) != 0)
+		err(1, "Bringing interface %s up", devname);
+
+	if (ioctl(fd, SIOCGIFHWADDR, &ifr) != 0)
+		err(1, "getting hw address for %s", devname);
+
+	memcpy(hwaddr, ifr.ifr_hwaddr.sa_data, 6);
+}
+
+/* We send lguest_add signals while input is pending: avoids races. */
+static void wake_parent(int pipefd, struct devices *devices)
+{
+	int parent = getppid();
+	nice(19);
+
+	set_fd(pipefd, devices);
+
+	for (;;) {
+		fd_set rfds = devices->infds;
+
+		select(devices->max_infd+1, &rfds, NULL, NULL, NULL);
+		if (FD_ISSET(pipefd, &rfds)) {
+			int ignorefd;
+			if (read(pipefd, &ignorefd, sizeof(ignorefd)) == 0)
+				exit(0);
+			FD_CLR(ignorefd, &devices->infds);
+		}
+		kill(parent, SIGUSR1);
+	}
+}
+
+/* We don't want signal to kill us, just jerk us out of kernel. */
+static void wakeup(int signo)
+{
+}
+
+static int handle_tun_input(int fd, struct device *dev)
+{
+	u32 irq = 0, num, *lenp;
+	int len;
+	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
+
+	lenp = get_dma_buffer(fd, dev->mem+peer_offset(NET_PEERNUM), iov, &num,
+			      &irq);
+	if (!lenp) {
+		if (*(bool *)dev->priv)
+			warn("network: no dma buffer!");
+		iov[0] = discard_iov;
+		num = 1;
+	}
+
+	len = readv(dev->fd, iov, num);
+	if (len <= 0)
+		err(1, "reading network");
+	if (lenp) {
+		*lenp = len;
+		trigger_irq(fd, irq);
+	}
+	verbose("tun input packet len %i [%02x %02x] (%s)\n", len,
+		((u8 *)iov[0].iov_base)[0], ((u8 *)iov[0].iov_base)[1],
+		lenp ? "sent" : "discarded");
+	return 1;
+}
+
+/* We use fnctl locks to reserve network slots (autocleanup!) */
+static unsigned int find_slot(int netfd, const char *filename)
+{
+	struct flock fl;
+
+	fl.l_type = F_WRLCK;
+	fl.l_whence = SEEK_SET;
+	fl.l_len = 1;
+	for (fl.l_start = 0;
+	     fl.l_start < getpagesize()/sizeof(struct lguest_net);
+	     fl.l_start++) {
+		if (fcntl(netfd, F_SETLK, &fl) == 0)
+			return fl.l_start;
+	}
+	errx(1, "No free slots in network file %s", filename);
+}
+
+static void setup_net_file(const char *filename,
+			   struct lguest_device_desc *descs,
+			   struct devices *devices)
+{
+	int netfd;
+	struct device *dev;
+
+	netfd = open(filename, O_RDWR, 0);
+	if (netfd < 0) {
+		if (errno == ENOENT) {
+			netfd = open(filename, O_RDWR|O_CREAT, 0600);
+			if (netfd >= 0) {
+				char page[getpagesize()];
+				/* 0xFFFF == NO_GUEST */
+				memset(page, 0xFF, sizeof(page));
+				write(netfd, page, sizeof(page));
+			}
+		}
+		if (netfd < 0)
+			err(1, "cannot open net file '%s'", filename);
+	}
+
+	dev = new_device(devices, descs, LGUEST_DEVICE_T_NET, 1,
+			 -1, NULL, 0, NULL);
+
+	/* This is the slot for the guest to use. */
+	dev->desc->features = find_slot(netfd, filename)|LGUEST_NET_F_NOCSUM;
+	/* We overwrite the /dev/zero mapping with the actual file. */
+	if (mmap(dev->mem, getpagesize(), PROT_READ|PROT_WRITE,
+			 MAP_FIXED|MAP_SHARED, netfd, 0) != dev->mem)
+			err(1, "could not mmap '%s'", filename);
+	verbose("device %p@%p: shared net %s, peer %i\n", dev->desc,
+		(void *)(dev->desc->pfn * getpagesize()), filename,
+		dev->desc->features & ~LGUEST_NET_F_NOCSUM);
+}
+
+static u32 str2ip(const char *ipaddr)
+{
+	unsigned int byte[4];
+
+	sscanf(ipaddr, "%u.%u.%u.%u", &byte[0], &byte[1], &byte[2], &byte[3]);
+	return (byte[0] << 24) | (byte[1] << 16) | (byte[2] << 8) | byte[3];
+}
+
+static void setup_tun_net(const char *ipaddr,
+			  struct lguest_device_desc *descs,
+			  struct devices *devices)
+{
+	struct device *dev;
+	struct ifreq ifr;
+	int netfd;
+
+	netfd = open("/dev/net/tun", O_RDWR);
+	if (netfd < 0)
+		err(1, "opening /dev/net/tun");
+
+	memset(&ifr, 0, sizeof(ifr));
+	ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
+	strcpy(ifr.ifr_name, "tap%d");
+	if (ioctl(netfd, TUNSETIFF, &ifr) != 0)
+		err(1, "configuring /dev/net/tun");
+
+	dev = new_device(devices, descs, LGUEST_DEVICE_T_NET, 1,
+			 netfd, handle_tun_input,
+			 peer_offset(0), handle_tun_output);
+	dev->priv = malloc(sizeof(bool));
+	*(bool *)dev->priv = false;
+
+	/* We are peer 0, rest is all NO_GUEST */
+	memset(dev->mem, 0xFF, getpagesize());
+	configure_device(ifr.ifr_name, str2ip(ipaddr), dev->mem);
+
+	/* You will be peer 1: we should create enough jitter to randomize */
+	dev->desc->features = NET_PEERNUM|LGUEST_DEVICE_F_RANDOMNESS;
+	verbose("device %p@%p: tun net %u.%u.%u.%u\n", dev->desc,
+		(void *)(dev->desc->pfn * getpagesize()),
+		HIPQUAD(str2ip(ipaddr)));
+}
+
+static void setup_block_file(const char *filename,
+			     struct lguest_device_desc *descs,
+			     struct devices *devices)
+{
+	int fd;
+	struct device *dev;
+	off64_t *blocksize;
+	struct lguest_block_page *p;
+
+	fd = open(filename, O_RDWR|O_LARGEFILE|O_DIRECT, 0);
+	if (fd < 0)
+		err(1, "Opening %s", filename);
+
+	dev = new_device(devices, descs, LGUEST_DEVICE_T_BLOCK, 1,
+			 fd, NULL, 0, handle_block_output);
+	dev->desc->features = LGUEST_DEVICE_F_RANDOMNESS;
+	blocksize = dev->priv = malloc(sizeof(*blocksize));
+	*blocksize = lseek64(fd, 0, SEEK_END);
+	p = dev->mem;
+
+	p->num_sectors = *blocksize/512;
+	verbose("device %p@%p: block %i sectors\n", dev->desc,
+		(void *)(dev->desc->pfn * getpagesize()), p->num_sectors);
+}
+
+static u32 handle_console_output(int fd, const struct iovec *iov,
+				 unsigned num, struct device*dev)
+{
+	return writev(STDOUT_FILENO, iov, num);
+}
+
+static void setup_console(struct lguest_device_desc *descs,
+			  struct devices *devices)
+{
+	struct device *dev;
+
+	if (tcgetattr(STDIN_FILENO, &orig_term) == 0) {
+		struct termios term = orig_term;
+		term.c_lflag &= ~(ISIG|ICANON|ECHO);
+		tcsetattr(STDIN_FILENO, TCSANOW, &term);
+		atexit(restore_term);
+	}
+
+	/* We don't currently require a page for the console. */
+	dev = new_device(devices, descs, LGUEST_DEVICE_T_CONSOLE, 0,
+			 STDIN_FILENO, handle_console_input,
+			 4, handle_console_output);
+	dev->priv = malloc(sizeof(struct console_abort));
+	((struct console_abort *)dev->priv)->count = 0;
+	verbose("device %p@%p: console\n", dev->desc,
+		(void *)(dev->desc->pfn * getpagesize()));
+}
+
+static const char *get_arg(const char *arg, const char *prefix)
+{
+	if (strncmp(arg, prefix, strlen(prefix)) == 0)
+		return arg + strlen(prefix);
+	return NULL;
+}
+
+static u32 handle_device(int fd, unsigned long dma, unsigned long addr,
+			 struct devices *devices)
+{
+	struct device *i;
+	u32 *lenp;
+	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
+	unsigned num = 0;
+
+	lenp = dma2iov(dma, iov, &num);
+	if (!lenp)
+		errx(1, "Bad SEND_DMA %li for address %#lx\n", dma, addr);
+
+	for (i = devices->dev; i; i = i->next) {
+		if (i->handle_output && addr == i->watch_address) {
+			*lenp = i->handle_output(fd, iov, num, i);
+			return 0;
+		}
+	}
+	warnx("Pending dma %p, addr %p", (void *)dma, (void *)addr);
+	return 0;
+}
+
+static void handle_input(int fd, int childfd, struct devices *devices)
+{
+	struct timeval poll = { .tv_sec = 0, .tv_usec = 0 };
+
+	for (;;) {
+		struct device *i;
+		fd_set fds = devices->infds;
+
+		if (select(devices->max_infd+1, &fds, NULL, NULL, &poll) == 0)
+			break;
+
+		for (i = devices->dev; i; i = i->next) {
+			if (i->handle_input && FD_ISSET(i->fd, &fds)) {
+				if (!i->handle_input(fd, i)) {
+					FD_CLR(i->fd, &devices->infds);
+					/* Tell child to ignore it too... */
+					write(childfd, &i->fd, sizeof(i->fd));
+				}
+			}
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned long mem, pgdir, entry, initrd_size, page_offset;
+	int arg, kern_fd, fd, child, pipefd[2];
+	Elf32_Ehdr hdr;
+	struct sigaction act;
+	sigset_t sigset;
+	struct lguest_device_desc *devdescs;
+	struct devices devices;
+	struct lguest_boot_info *boot = (void *)0;
+	const char *initrd_name = NULL;
+	u32 (*load)(int, const Elf32_Ehdr *ehdr, unsigned long,
+		    unsigned long *, const char *, unsigned long *,
+		    unsigned long *);
+
+	if (argv[1] && strcmp(argv[1], "--verbose") == 0) {
+		verbose = true;
+		argv++;
+		argc--;
+	}
+
+	if (argc < 4)
+		errx(1, "Usage: lguest [--verbose] <mem> vmlinux "
+			"[--sharenet=<filename>|--tunnet=<ipaddr>|--block=<filename>"
+			"|--initrd=<filename>]... [args...]");
+
+	zero_fd = open("/dev/zero", O_RDONLY, 0);
+	if (zero_fd < 0)
+		err(1, "Opening /dev/zero");
+
+	mem = memparse(argv[1]);
+	kern_fd = open(argv[2], O_RDONLY, 0);
+	if (kern_fd < 0)
+		err(1, "Opening %s", argv[2]);
+
+	if (read(kern_fd, &hdr, sizeof(hdr)) != sizeof(hdr))
+		err(1, "Reading %s elf header", argv[2]);
+
+	if (memcmp(hdr.e_ident, ELFMAG, SELFMAG) == 0)
+		load = map_elf;
+	else
+		load = load_bzimage;
+
+	devices.max_infd = -1;
+	devices.dev = NULL;
+	FD_ZERO(&devices.infds);
+
+	devdescs = map_pages(mem, 1);
+	arg = 3;
+	while (argv[arg] && argv[arg][0] == '-') {
+		const char *argval;
+
+		if ((argval = get_arg(argv[arg], "--sharenet=")) != NULL)
+			setup_net_file(argval, devdescs, &devices);
+		else if ((argval = get_arg(argv[arg], "--tunnet=")) != NULL)
+			setup_tun_net(argval, devdescs, &devices);
+		else if ((argval = get_arg(argv[arg], "--block=")) != NULL)
+			setup_block_file(argval, devdescs, &devices);
+		else if ((argval = get_arg(argv[arg], "--initrd=")) != NULL)
+			initrd_name = argval;
+		else
+			errx(1, "unknown arg '%s'", argv[arg]);
+		arg++;
+	}
+
+	entry = load(kern_fd, &hdr, mem, &pgdir, initrd_name, &initrd_size,
+		     &page_offset);
+	setup_console(devdescs, &devices);
+
+	concat(boot->cmdline, argv+arg);
+	boot->max_pfn = mem/getpagesize();
+	boot->initrd_size = initrd_size;
+
+	act.sa_handler = wakeup;
+	sigemptyset(&act.sa_mask);
+	act.sa_flags = 0;
+	sigaction(SIGUSR1, &act, NULL);
+
+	pipe(pipefd);
+	child = fork();
+	if (child == -1)
+		err(1, "forking");
+
+	if (child == 0) {
+		close(pipefd[1]);
+		wake_parent(pipefd[0], &devices);
+	}
+	close(pipefd[0]);
+
+	sigemptyset(&sigset);
+	sigaddset(&sigset, SIGUSR1);
+	sigprocmask(SIG_BLOCK, &sigset, NULL);
+
+	/* LGUEST_GUEST_TOP defined in Makefile, just below us. */
+	fd = tell_kernel(LGUEST_GUEST_TOP/getpagesize(),
+			 pgdir, entry, page_offset);
+
+	for (;;) {
+		unsigned long arr[2];
+		int readval;
+
+		sigprocmask(SIG_UNBLOCK, &sigset, NULL);
+		readval = read(fd, arr, sizeof(arr));
+		sigprocmask(SIG_BLOCK, &sigset, NULL);
+
+		switch (readval) {
+		case sizeof(arr):
+			handle_device(fd, arr[0], arr[1], &devices);
+			break;
+		case -1:
+			if (errno == EINTR)
+				break;
+		default:
+			if (errno == ENOENT) {
+				char reason[1024];
+				if (read(fd, reason, sizeof(reason)) > 0)
+					errx(1, "%s", reason);
+			}
+			err(1, "Running guest failed");
+		}
+		handle_input(fd, pipefd[1], &devices);
+	}
+}
diff -puN /dev/null Documentation/lguest/lguest.txt
--- /dev/null
+++ a/Documentation/lguest/lguest.txt
@@ -0,0 +1,355 @@
+Rusty's Remarkably Unreliable Guide to Lguest
+	- or, A Young Coder's Illustrated Hypervisor
+http://lguest.ozlabs.org
+
+Lguest is designed to be a minimal hypervisor for the Linux kernel, for
+Linux developers and users to experiment with virtualization with the
+minimum of complexity.  Nonetheless, it should have sufficient
+features to make it useful for specific tasks, and, of course, you are
+encouraged to fork and enhance it.
+
+Features:
+
+- Kernel module which runs in a normal kernel.
+- Simple I/O model for communication.
+- Simple program to create new guests.
+- Logo contains cute puppies: http://lguest.ozlabs.org
+
+Developer features:
+
+- Fun to hack on.
+- No ABI: being tied to a specific kernel anyway, you can change anything.
+- Many opportunities for improvement or feature implementation.
+
+Running Lguest:
+
+- You will need to configure your kernel with the following options:
+
+  CONFIG_HIGHMEM64G=n ("High Memory Support" "64GB")[1]
+  CONFIG_TUN=y/m ("Universal TUN/TAP device driver support")
+  CONFIG_EXPERIMENTAL=y ("Prompt for development and/or incomplete code/drivers")
+  CONFIG_PARAVIRT=y ("Paravirtualization support (EXPERIMENTAL)")
+  CONFIG_LGUEST=y/m ("Linux hypervisor example code")
+
+  and I recommend:
+  CONFIG_HZ=100 ("Timer frequency")[2]
+
+  You must have a machine with a TSC: look for "tsc" in /proc/cpuinfo.
+  It's simple to remove this restriction, but everyone has a TSC these
+  days.
+
+- A tool called "lguest" is available in this directory: type "make"
+  to build it.
+
+- Create or find a root disk image.  There are several useful ones
+  around, such as the xm-test tiny root image at
+	  http://xm-test.xensource.com/ramdisks/initrd-1.1-i386.img
+
+  For more serious work, I usually use a distribution ISO image and
+  install it under qemu, then make multiple copies:
+
+	  dd if=/dev/zero of=rootfile bs=1M count=2048
+	  qemu -cdrom image.iso -hda rootfile -net user -net nic -boot d
+
+- "modprobe lg" if you built it as a module.
+
+- Run an lguest as root:
+
+      Documentation/lguest/lguest 64m vmlinux --tunnet=192.168.19.1 --block=rootfile root=/dev/lgba
+
+   Explanation:
+    64m: the amount of memory to use.
+
+    vmlinux: the kernel image found in the top of your build directory.  You
+       can also use a standard bzImage.
+
+    --tunnet=192.168.19.1: configures a "tap" device for networking with this
+       IP address.
+
+    --block=rootfile: a file or block device which becomes /dev/lgba
+       inside the guest.
+
+    root=/dev/lgba: this (and anything else on the command line) are
+       kernel boot parameters.
+
+- Configuring networking.  I usually have the host masquerade, using
+  "iptables -t nat -o eth0 -j MASQUERADE" and "echo 1 >
+  /proc/sys/net/ipv4/ip_forward".  In this example, I would configure
+  eth0 inside the guest at 192.168.19.2.
+
+- You can also create an inter-guest network using
+  "--sharenet=<filename>": any two guests using the same file are on
+  the same network.  This file is created if it does not exist.
+
+
+Lguest I/O model:
+
+Lguest uses a simplified DMA model plus shared memory for I/O.  Guests
+can communicate with each other if they share underlying memory
+(usually by the lguest program mmaping the same file), but they can
+use any non-shared memory to communicate with the lguest process.
+
+Guests can register DMA buffers at any physical address using the
+LHCALL_BIND_DMA(physaddr, dmabufs, num<<8|irq) hypercall.  "dmabufs"
+is the physical address of an array of "num" "struct lguest_dma": each
+contains a used_len, and an array of physical addresses and lengths.
+When a transfer occurs, the "used_len" field of one of the buffers
+which has used_len 0 will be set to the length transferred and the irq
+will fire.
+
+Using an irq value of 0 unbinds the dma buffers.
+
+To send DMA, the LHCALL_SEND_DMA(physaddr, dma_physaddr) hypercall is
+used, and the bytes used is written to the used_len field.  This can
+be 0 if noone else has bound a DMA buffer to that address or some
+other error.  DMA buffers bound by the same guest are ignored.
+
+
+Hacking on Lguest:
+
+Lguest uses the paravirt_ops infrastructure to override various
+sensitive operations so Linux can run in ring level 1 (rather
+than 0).  These operations make "hypercalls": traps into a tiny shim
+which is mapped at the top of memory which then switches back to the
+host Linux for servicing.  In fact, any real interrupt and many
+traps cause a switch back to the host, which doesn't even notice that
+it was switched out.  This means that the guest process is scheduled
+like any other process, although it spends most of its time in its own
+special address space.
+
+Here are the parts of the hypervisor at the moment:
+
+hypervisor.S:
+	The assembler shim which is mapped at 0xFFC01000 (-4M+1page)
+	in the host and all the guests.  This is built into a .o file
+	and inserted in the source as a C array: it is simply copied
+	into the mapped memory.
+
+	The shim is entered from the host at switch_to_guest with
+	interrupts off: this saves state and switches page tables,
+	GDT, IDT, TSS and stack, then dives into the guest with an
+	iret.
+
+	There are two ways back to the host: a trap or an external
+	interrupt.  A trap, such as a page fault, goes through
+	return_to_host, which simply switches back and irets to the
+	caller (init.c's lcall), which decides what to do.  For an
+	interrupt we call deliver_to_host, which switches to the host
+	then jumps straight to the host interrupt routine: the
+	interrupt routine will do an "iret" at some stage, which, now
+	we've switched stacks, will return to the caller in init.c.
+
+page_tables.c:
+	We cannot let guests control their own pagetables, since they
+	must not access others' memory and their concept of physical
+	addresses is not related to the real physical addresses: the
+	guest "physical" addresses are in fact virtual addresses in
+	the host's lguest thread.  The process of mapping the two
+	can be fairly complicated.
+
+	We keep up to 4 cached page tables.  When a page is referred
+	to by these guest "shadow" pagetables, we keep a reference to
+	it to prevent the Linux kernel from thinking it is unused and
+	paging it out underneath us.
+	FIXME: it would be much better to have a callback in mm_struct.
+
+	The main work is done in page_in.  First we check the
+	top-level guest page table: if that entry is not present, then
+	it's a real guest fault and we reflect it to the guest.
+	Otherwise, we check the real top level, and allocate a new
+	pagetable page if necessary.  Then we check the next level of
+	the guest page table: if that isn't present, or this was a
+	write and the guest entry is read only, we reflect it to the
+	guest.  Otherwise, we check the guest entry, convert the page
+	number to the actual physical page number, then set it in our
+	page table.  At this point we also update the accessed and
+	dirty bits in the guest.
+
+	So a guest's top-level pagetable starts empty, and over time
+	we fault more pages in.  If the guest switches page tables, we
+	see if it's in out 4-entry cache: if not, we clear the
+	non-kernel section of one of them and use that.  (The kernel
+	page table entries will always be the same in all top levels).
+
+	We have to keep the stack pages for the guest kernel mapped at
+	all times, since we point some traps (particularly system
+	calls) directly into the guest.  If the stack were not mapped
+	we would get a double fault, which means we kill the guest.
+
+	Note that there are three page tables for each guest: the
+	Linux host ones which exist for lguest just like any other
+	process, the actual ones used when we switch to running the
+	guest, and the ones inside the guest which it thinks it's
+	using (and we copy to the actual ones after checking).
+
+hypercalls.c:
+	This is where the guest used int 0x1F to ask the hypervisor
+	for something.  The first hypercall is always
+	LHCALL_LGUEST_INIT, which tells us where the "struct
+	lguest_page" is.  We populate the lguest_page with useful
+	information, and it's also used to indicate virtual interrupts
+	and whether the guest expects interrupts to be disabled.
+
+	Most of these calls are fairly self-explanatory, or covered
+	elsewhere.  Note that LHCALL_CRASH allows a guest to get a
+	message out before any devices are enabled, which can be
+	useful for debugging.
+
+	do_async_hypercalls: a ringbuffer in the lguest page allows
+	the guest to queue hypercalls for later execution.  This is
+	useful for hypercall batching during context switch, and for
+	some bulk I/O.  The return value of the hypercall is
+	discarded, so it doesn't make sense to batch some hypercalls.
+	Note that we always do all these "async" calls before any
+	normal hypercall, which means that any hypercall acts as a
+	flush operation.  The only trick is that an async SEND_DMA
+	hypercall may need to be serviced by the host userspace; the
+	run_guest loop is constructed so that we continue servicing
+	hypercalls when we re-enter the loop after host userspace has
+	done the I/O operation.
+
+	setup_trampoline: this populates a stub for direct traps to
+	the guest.  Using a trampoline page (which sits just below the
+	hypervisor at -4M) ensures that the page is always mapped, and
+	also ensures that we reload the %gs register before entering the
+	kernel (see guest_load_tls).
+
+io.c:
+	lguest provides DMA-style transfer, and buffer registration.
+	The guest can dma send to a particular address, or register a
+	set of DMA buffers at a particular address.  This provides
+	inter-guest I/O (for shared addresses, such as a shared mmap)
+	or I/O out to the userspace process (lguest).
+
+	We currently use the futex infrastructure to see if a given
+	address is shared: if it is, we look for another guest which
+	has registered a DMA buffer at this address and copy the data,
+	then interrupt the recipient.  Otherwise, we notify the guest
+	userspace (which has access to all the guest memory) to handle
+	the transfer.
+
+	TODO: We could flip whole pages between guests at this point
+	if we wanted to, however it seems unlikely to be worthwhile.
+	More optimization could be gained by having servers for certain
+	devices within the host kernel itself, avoiding at
+	least two switches into the lguest binary and back.
+
+core.c:
+	This contains the core of lguest, "run_guest", which
+	continuously lcalls into the switch_to_guest routine until
+	something interesting happens.  In particular, we only return
+	to userspace (ie. "lguest") when a signal occurs or the guest
+	does a SEND_DMA destined for host userspace.
+
+	emulate_insn(): we don't paravirtualize io and out
+	instructions, so we trap and emulate them here.  This is only
+	used when the guest is booting and probing for PCI busses,
+	etc.
+
+	lguest_address_ok(): the guest kernel must not be able to
+	access the lguest binary, otherwise it could break out of
+	its virtualization, so all dereferences must use the
+	lhread_u32/lhwrite_u32/lhread/lhwrite routines which check
+	this.
+
+	reflect_trap(): when we decide that the guest should handle a
+	trap (a page fault, a general protection fault, an FPU fault
+	or a virtual interrupt), we manually push a trap frame onto
+	its stack as it expects it to be.  There are two kinds of
+	traps for x86: interrupt gates expect to have interrupts
+	disabled, and trap gates expect interrupts to be left alone.
+	The guest will restore interrupts in lguest_iret.
+
+	Of course, we don't actually let the guest disable interrupts,
+	just prevent us from delivering interupts to that guest (the
+	flag "irq_enabled" in the lguest_page).
+
+	kill_guest: this is used when an error occurs which can only
+	be caused by the guest kernel.  You can continue as normal
+	after this: the guest will exit when it returns to run_thread.
+
+	fixup_gdt_table: we protect the hypervisor shim from being
+	accessed using segments, so we have to trim segments the guest
+	uses to exclude the hypervisor.  The shim itself uses two
+	segments (only accessible to ring 0) which map the entire
+	memory range, and we use our own TSS entry.
+
+	guest_load_tls: glibc implements __thread using
+	thread-local-storage segments.  These segments start at a
+	different offset for each thread, and cover the entire 4GB
+	address space.  glibc then uses huge offsets into this segment
+	to wrap around and access variables below that offset.
+	Unfortunately, we cannot allow this in general, as this would
+	allow access to the hypervisor shim!  Fortunately, x86 page
+	table entries contain a "user" bit, which when cleared makes
+	pages inaccessible to ring level 3.  We clear this bit for the
+	pagetable entries mapping the hypervisor, so we can allow ring
+	3 (ie. userspace) access to 4G segments.  If the guest is in
+	ring 3, we setup the segment limits at the full 4G just before
+	calling into hypervisor.S.  It will reload %gs, then truncate
+	these TLS segments to a single page.  This ensures that any
+	reload of gs gets the truncated segments.  As the guest
+	userspace will also load %gs itself, we ignore the first
+	protection fault that occurs at any given address in userspace
+	(assuming it's caused by use of the truncated segment).  As
+	all traps reload gs explicitly (trampoline page) or implicitly
+	(reflect_trap), they all must reset the pointer to the
+	last-detected faulting instruction, as they will fault again.
+
+device.c:
+	This contains the host userspace interface code	(ie. /dev/lguest).
+
+	The read and write routines are where the userspace program
+	lguest starts and performs I/O to the guest.  The initial
+	write supplies the number of memory pages, the access limit
+	(which is used to ensure the guest doesn't overwrite the
+	lguest binary which sits above this address), the initial
+	guest pagetable top, and the address to jump into the guest
+	image.  Reading from the file causes the guest to run until a
+	signal or I/O is pending.
+
+lguest_bus.c:
+	A simple bus which sits in the lguest_page and indicates what
+	devices are available.  Using the interrupt model it would be
+	easy to make this dynamic.
+
+drivers/net/lguest_net.c:
+	A simple network device, which (invisible to the guest) can be
+	shared between several guests or simply talk to the lguest
+	process.  There is only one unusual element: the sender
+	needs to find the packet destination.
+
+	We manually scan the shared page for mac addresses to decide
+	where to send a packet.  We overload an unusable bit in that
+	mac address to indicate promiscuous mode (so the sender knows
+	to send a copy of all packets to that recipient).
+
+drivers/char/hvc_lguest.c:
+	A simple console.  It could use a shared page as a ringbuffer
+	and merely use the dma mechanism for notifications, but using
+	DMA directly is less code.
+
+	TODO: The console input can be flooded if it doesn't service
+	fast enough, and will lose characters.  If this is a problem,
+	switch to ringbuffer or use multiple DMA buffers and define an
+	ordering.
+
+drivers/block/lguest_blk.c:
+	A simple block device.  It's actually overkill for the current
+	use: talking to the userspace side is synchronous, but this allows
+	it to be served by something else in future.
+
+arch/i386/kernel/lguest.c:
+	The guest paravirt_ops implementation.  The only complexity is
+	in the implementation of lguest_iret: we need to restore the
+	interrupt state and return from the interrupt atomically.  To
+	this end, we tell the hypervisor that it is not to interrupt
+	us in those instructions between the restoration (usually
+	enabling) of interrupts and the actual "iret".
+
+Cheers!
+Rusty Russell rusty@rustcorp.com.au.
+
+[1] These are on various places on the TODO list, waiting for you to
+    get annoyed enough at the limitation to fix it.
+[2] Lguest is not yet tickless when idle.  See [1].
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
cleanup-paravirt-unhandled-fallthrough.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
cleanup-move-mce_disabled-to-asm-mceh.patch
cleanup-rename-cpu_gdt_descr-and-remove-extern.patch
cleanup-remove-extern-declaration-from.patch
cleanup-make-disable_acpi-valid-w-o-config_acpi.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
vmi-versus-hrtimers.patch
