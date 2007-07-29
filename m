From: akpm@linux-foundation.org
Subject: - lguest-documentation-iv-launcher.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:33 -0700
Message-ID: <200707290611.l6T6BX2M010992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757460AbXG2GL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:11:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: documentation IV: Launcher
has been removed from the -mm tree.  Its filename was
     lguest-documentation-iv-launcher.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lguest: documentation IV: Launcher
From: Rusty Russell <rusty@rustcorp.com.au>

Documentation: The Launcher

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lguest/lguest.c |  599 +++++++++++++++++++++++++++++---
 drivers/lguest/core.c         |   24 +
 drivers/lguest/io.c           |  247 ++++++++++++-
 drivers/lguest/lg.h           |   25 +
 drivers/lguest/lguest_user.c  |  159 ++++++++
 5 files changed, 982 insertions(+), 72 deletions(-)

diff -puN Documentation/lguest/lguest.c~lguest-documentation-iv-launcher Documentation/lguest/lguest.c
--- a/Documentation/lguest/lguest.c~lguest-documentation-iv-launcher
+++ a/Documentation/lguest/lguest.c
@@ -34,12 +34,20 @@
 #include <termios.h>
 #include <getopt.h>
 #include <zlib.h>
+/*L:110 We can ignore the 28 include files we need for this program, but I do
+ * want to draw attention to the use of kernel-style types.
+ *
+ * As Linus said, "C is a Spartan language, and so should your naming be."  I
+ * like these abbreviations and the header we need uses them, so we define them
+ * here.
+ */
 typedef unsigned long long u64;
 typedef uint32_t u32;
 typedef uint16_t u16;
 typedef uint8_t u8;
 #include "../../include/linux/lguest_launcher.h"
 #include "../../include/asm-i386/e820.h"
+/*:*/
 
 #define PAGE_PRESENT 0x7 	/* Present, RW, Execute */
 #define NET_PEERNUM 1
@@ -48,33 +56,52 @@ typedef uint8_t u8;
 #define SIOCBRADDIF	0x89a2		/* add interface to bridge      */
 #endif
 
+/*L:120 verbose is both a global flag and a macro.  The C preprocessor allows
+ * this, and although I wouldn't recommend it, it works quite nicely here. */
 static bool verbose;
 #define verbose(args...) \
 	do { if (verbose) printf(args); } while(0)
+/*:*/
+
+/* The pipe to send commands to the waker process */
 static int waker_fd;
+/* The top of guest physical memory. */
 static u32 top;
 
+/* This is our list of devices. */
 struct device_list
 {
+	/* Summary information about the devices in our list: ready to pass to
+	 * select() to ask which need servicing.*/
 	fd_set infds;
 	int max_infd;
 
+	/* The descriptor page for the devices. */
 	struct lguest_device_desc *descs;
+
+	/* A single linked list of devices. */
 	struct device *dev;
+	/* ... And an end pointer so we can easily append new devices */
 	struct device **lastdev;
 };
 
+/* The device structure describes a single device. */
 struct device
 {
+	/* The linked-list pointer. */
 	struct device *next;
+	/* The descriptor for this device, as mapped into the Guest. */
 	struct lguest_device_desc *desc;
+	/* The memory page(s) of this device, if any.  Also mapped in Guest. */
 	void *mem;
 
-	/* Watch this fd if handle_input non-NULL. */
+	/* If handle_input is set, it wants to be called when this file
+	 * descriptor is ready. */
 	int fd;
 	bool (*handle_input)(int fd, struct device *me);
 
-	/* Watch DMA to this key if handle_input non-NULL. */
+	/* If handle_output is set, it wants to be called when the Guest sends
+	 * DMA to this key. */
 	unsigned long watch_key;
 	u32 (*handle_output)(int fd, const struct iovec *iov,
 			     unsigned int num, struct device *me);
@@ -83,6 +110,11 @@ struct device
 	void *priv;
 };
 
+/*L:130
+ * Loading the Kernel.
+ *
+ * We start with couple of simple helper routines.  open_or_die() avoids
+ * error-checking code cluttering the callers: */
 static int open_or_die(const char *name, int flags)
 {
 	int fd = open(name, flags);
@@ -91,26 +123,38 @@ static int open_or_die(const char *name,
 	return fd;
 }
 
+/* map_zeroed_pages() takes a (page-aligned) address and a number of pages. */
 static void *map_zeroed_pages(unsigned long addr, unsigned int num)
 {
+	/* We cache the /dev/zero file-descriptor so we only open it once. */
 	static int fd = -1;
 
 	if (fd == -1)
 		fd = open_or_die("/dev/zero", O_RDONLY);
 
+	/* We use a private mapping (ie. if we write to the page, it will be
+	 * copied), and obviously we insist that it be mapped where we ask. */
 	if (mmap((void *)addr, getpagesize() * num,
 		 PROT_READ|PROT_WRITE|PROT_EXEC, MAP_FIXED|MAP_PRIVATE, fd, 0)
 	    != (void *)addr)
 		err(1, "Mmaping %u pages of /dev/zero @%p", num, (void *)addr);
+
+	/* Returning the address is just a courtesy: can simplify callers. */
 	return (void *)addr;
 }
 
-/* Find magic string marking entry point, return entry point. */
+/* To find out where to start we look for the magic Guest string, which marks
+ * the code we see in lguest_asm.S.  This is a hack which we are currently
+ * plotting to replace with the normal Linux entry point. */
 static unsigned long entry_point(void *start, void *end,
 				 unsigned long page_offset)
 {
 	void *p;
 
+	/* The scan gives us the physical starting address.  We want the
+	 * virtual address in this case, and fortunately, we already figured
+	 * out the physical-virtual difference and passed it here in
+	 * "page_offset". */
 	for (p = start; p < end; p++)
 		if (memcmp(p, "GenuineLguest", strlen("GenuineLguest")) == 0)
 			return (long)p + strlen("GenuineLguest") + page_offset;
@@ -118,7 +162,17 @@ static unsigned long entry_point(void *s
 	err(1, "Is this image a genuine lguest?");
 }
 
-/* Returns the entry point */
+/* This routine takes an open vmlinux image, which is in ELF, and maps it into
+ * the Guest memory.  ELF = Embedded Linking Format, which is the format used
+ * by all modern binaries on Linux including the kernel.
+ *
+ * The ELF headers give *two* addresses: a physical address, and a virtual
+ * address.  The Guest kernel expects to be placed in memory at the physical
+ * address, and the page tables set up so it will correspond to that virtual
+ * address.  We return the difference between the virtual and physical
+ * addresses in the "page_offset" pointer.
+ *
+ * We return the starting address. */
 static unsigned long map_elf(int elf_fd, const Elf32_Ehdr *ehdr,
 			     unsigned long *page_offset)
 {
@@ -127,40 +181,61 @@ static unsigned long map_elf(int elf_fd,
 	unsigned int i;
 	unsigned long start = -1UL, end = 0;
 
-	/* Sanity checks. */
+	/* Sanity checks on the main ELF header: an x86 executable with a
+	 * reasonable number of correctly-sized program headers. */
 	if (ehdr->e_type != ET_EXEC
 	    || ehdr->e_machine != EM_386
 	    || ehdr->e_phentsize != sizeof(Elf32_Phdr)
 	    || ehdr->e_phnum < 1 || ehdr->e_phnum > 65536U/sizeof(Elf32_Phdr))
 		errx(1, "Malformed elf header");
 
+	/* An ELF executable contains an ELF header and a number of "program"
+	 * headers which indicate which parts ("segments") of the program to
+	 * load where. */
+
+	/* We read in all the program headers at once: */
 	if (lseek(elf_fd, ehdr->e_phoff, SEEK_SET) < 0)
 		err(1, "Seeking to program headers");
 	if (read(elf_fd, phdr, sizeof(phdr)) != sizeof(phdr))
 		err(1, "Reading program headers");
 
+	/* We don't know page_offset yet. */
 	*page_offset = 0;
-	/* We map the loadable segments at virtual addresses corresponding
-	 * to their physical addresses (our virtual == guest physical). */
+
+	/* Try all the headers: there are usually only three.  A read-only one,
+	 * a read-write one, and a "note" section which isn't loadable. */
 	for (i = 0; i < ehdr->e_phnum; i++) {
+		/* If this isn't a loadable segment, we ignore it */
 		if (phdr[i].p_type != PT_LOAD)
 			continue;
 
 		verbose("Section %i: size %i addr %p\n",
 			i, phdr[i].p_memsz, (void *)phdr[i].p_paddr);
 
-		/* We expect linear address space. */
+		/* We expect a simple linear address space: every segment must
+		 * have the same difference between virtual (p_vaddr) and
+		 * physical (p_paddr) address. */
 		if (!*page_offset)
 			*page_offset = phdr[i].p_vaddr - phdr[i].p_paddr;
 		else if (*page_offset != phdr[i].p_vaddr - phdr[i].p_paddr)
 			errx(1, "Page offset of section %i different", i);
 
+		/* We track the first and last address we mapped, so we can
+		 * tell entry_point() where to scan. */
 		if (phdr[i].p_paddr < start)
 			start = phdr[i].p_paddr;
 		if (phdr[i].p_paddr + phdr[i].p_filesz > end)
 			end = phdr[i].p_paddr + phdr[i].p_filesz;
 
-		/* We map everything private, writable. */
+		/* We map this section of the file at its physical address.  We
+		 * map it read & write even if the header says this segment is
+		 * read-only.  The kernel really wants to be writable: it
+		 * patches its own instructions which would normally be
+		 * read-only.
+		 *
+		 * MAP_PRIVATE means that the page won't be copied until a
+		 * write is done to it.  This allows us to share much of the
+		 * kernel memory between Guests. */
 		addr = mmap((void *)phdr[i].p_paddr,
 			    phdr[i].p_filesz,
 			    PROT_READ|PROT_WRITE|PROT_EXEC,
@@ -174,7 +249,31 @@ static unsigned long map_elf(int elf_fd,
 	return entry_point((void *)start, (void *)end, *page_offset);
 }
 
-/* This is amazingly reliable. */
+/*L:170 Prepare to be SHOCKED and AMAZED.  And possibly a trifle nauseated.
+ *
+ * We know that CONFIG_PAGE_OFFSET sets what virtual address the kernel expects
+ * to be.  We don't know what that option was, but we can figure it out
+ * approximately by looking at the addresses in the code.  I chose the common
+ * case of reading a memory location into the %eax register:
+ *
+ *  movl <some-address>, %eax
+ *
+ * This gets encoded as five bytes: "0xA1 <4-byte-address>".  For example,
+ * "0xA1 0x18 0x60 0x47 0xC0" reads the address 0xC0476018 into %eax.
+ *
+ * In this example can guess that the kernel was compiled with
+ * CONFIG_PAGE_OFFSET set to 0xC0000000 (it's always a round number).  If the
+ * kernel were larger than 16MB, we might see 0xC1 addresses show up, but our
+ * kernel isn't that bloated yet.
+ *
+ * Unfortunately, x86 has variable-length instructions, so finding this
+ * particular instruction properly involves writing a disassembler.  Instead,
+ * we rely on statistics.  We look for "0xA1" and tally the different bytes
+ * which occur 4 bytes later (the "0xC0" in our example above).  When one of
+ * those bytes appears three times, we can be reasonably confident that it
+ * forms the start of CONFIG_PAGE_OFFSET.
+ *
+ * This is amazingly reliable. */
 static unsigned long intuit_page_offset(unsigned char *img, unsigned long len)
 {
 	unsigned int i, possibilities[256] = { 0 };
@@ -187,30 +286,52 @@ static unsigned long intuit_page_offset(
 	errx(1, "could not determine page offset");
 }
 
+/*L:160 Unfortunately the entire ELF image isn't compressed: the segments
+ * which need loading are extracted and compressed raw.  This denies us the
+ * information we need to make a fully-general loader. */
 static unsigned long unpack_bzimage(int fd, unsigned long *page_offset)
 {
 	gzFile f;
 	int ret, len = 0;
+	/* A bzImage always gets loaded at physical address 1M.  This is
+	 * actually configurable as CONFIG_PHYSICAL_START, but as the comment
+	 * there says, "Don't change this unless you know what you are doing".
+	 * Indeed. */
 	void *img = (void *)0x100000;
 
+	/* gzdopen takes our file descriptor (carefully placed at the start of
+	 * the GZIP header we found) and returns a gzFile. */
 	f = gzdopen(fd, "rb");
+	/* We read it into memory in 64k chunks until we hit the end. */
 	while ((ret = gzread(f, img + len, 65536)) > 0)
 		len += ret;
 	if (ret < 0)
 		err(1, "reading image from bzImage");
 
 	verbose("Unpacked size %i addr %p\n", len, img);
+
+	/* Without the ELF header, we can't tell virtual-physical gap.  This is
+	 * CONFIG_PAGE_OFFSET, and people do actually change it.  Fortunately,
+	 * I have a clever way of figuring it out from the code itself.  */
 	*page_offset = intuit_page_offset(img, len);
 
 	return entry_point(img, img + len, *page_offset);
 }
 
+/*L:150 A bzImage, unlike an ELF file, is not meant to be loaded.  You're
+ * supposed to jump into it and it will unpack itself.  We can't do that
+ * because the Guest can't run the unpacking code, and adding features to
+ * lguest kills puppies, so we don't want to.
+ *
+ * The bzImage is formed by putting the decompressing code in front of the
+ * compressed kernel code.  So we can simple scan through it looking for the
+ * first "gzip" header, and start decompressing from there. */
 static unsigned long load_bzimage(int fd, unsigned long *page_offset)
 {
 	unsigned char c;
 	int state = 0;
 
-	/* Ugly brute force search for gzip header. */
+	/* GZIP header is 0x1F 0x8B <method> <flags>... <compressed-by>. */
 	while (read(fd, &c, 1) == 1) {
 		switch (state) {
 		case 0:
@@ -227,8 +348,10 @@ static unsigned long load_bzimage(int fd
 			state++;
 			break;
 		case 9:
+			/* Seek back to the start of the gzip header. */
 			lseek(fd, -10, SEEK_CUR);
-			if (c != 0x03) /* Compressed under UNIX. */
+			/* One final check: "compressed under UNIX". */
+			if (c != 0x03)
 				state = -1;
 			else
 				return unpack_bzimage(fd, page_offset);
@@ -237,25 +360,43 @@ static unsigned long load_bzimage(int fd
 	errx(1, "Could not find kernel in bzImage");
 }
 
+/*L:140 Loading the kernel is easy when it's a "vmlinux", but most kernels
+ * come wrapped up in the self-decompressing "bzImage" format.  With some funky
+ * coding, we can load those, too. */
 static unsigned long load_kernel(int fd, unsigned long *page_offset)
 {
 	Elf32_Ehdr hdr;
 
+	/* Read in the first few bytes. */
 	if (read(fd, &hdr, sizeof(hdr)) != sizeof(hdr))
 		err(1, "Reading kernel");
 
+	/* If it's an ELF file, it starts with "\177ELF" */
 	if (memcmp(hdr.e_ident, ELFMAG, SELFMAG) == 0)
 		return map_elf(fd, &hdr, page_offset);
 
+	/* Otherwise we assume it's a bzImage, and try to unpack it */
 	return load_bzimage(fd, page_offset);
 }
 
+/* This is a trivial little helper to align pages.  Andi Kleen hated it because
+ * it calls getpagesize() twice: "it's dumb code."
+ *
+ * Kernel guys get really het up about optimization, even when it's not
+ * necessary.  I leave this code as a reaction against that. */
 static inline unsigned long page_align(unsigned long addr)
 {
+	/* Add upwards and truncate downwards. */
 	return ((addr + getpagesize()-1) & ~(getpagesize()-1));
 }
 
-/* initrd gets loaded at top of memory: return length. */
+/*L:180 An "initial ram disk" is a disk image loaded into memory along with
+ * the kernel which the kernel can use to boot from without needing any
+ * drivers.  Most distributions now use this as standard: the initrd contains
+ * the code to load the appropriate driver modules for the current machine.
+ *
+ * Importantly, James Morris works for RedHat, and Fedora uses initrds for its
+ * kernels.  He sent me this (and tells me when I break it). */
 static unsigned long load_initrd(const char *name, unsigned long mem)
 {
 	int ifd;
@@ -264,21 +405,35 @@ static unsigned long load_initrd(const c
 	void *iaddr;
 
 	ifd = open_or_die(name, O_RDONLY);
+	/* fstat() is needed to get the file size. */
 	if (fstat(ifd, &st) < 0)
 		err(1, "fstat() on initrd '%s'", name);
 
+	/* The length needs to be rounded up to a page size: mmap needs the
+	 * address to be page aligned. */
 	len = page_align(st.st_size);
+	/* We map the initrd at the top of memory. */
 	iaddr = mmap((void *)mem - len, st.st_size,
 		     PROT_READ|PROT_EXEC|PROT_WRITE,
 		     MAP_FIXED|MAP_PRIVATE, ifd, 0);
 	if (iaddr != (void *)mem - len)
 		err(1, "Mmaping initrd '%s' returned %p not %p",
 		    name, iaddr, (void *)mem - len);
+	/* Once a file is mapped, you can close the file descriptor.  It's a
+	 * little odd, but quite useful. */
 	close(ifd);
 	verbose("mapped initrd %s size=%lu @ %p\n", name, st.st_size, iaddr);
+
+	/* We return the initrd size. */
 	return len;
 }
 
+/* Once we know how much memory we have, and the address the Guest kernel
+ * expects, we can construct simple linear page tables which will get the Guest
+ * far enough into the boot to create its own.
+ *
+ * We lay them out of the way, just below the initrd (which is why we need to
+ * know its size). */
 static unsigned long setup_pagetables(unsigned long mem,
 				      unsigned long initrd_size,
 				      unsigned long page_offset)
@@ -287,23 +442,32 @@ static unsigned long setup_pagetables(un
 	unsigned int mapped_pages, i, linear_pages;
 	unsigned int ptes_per_page = getpagesize()/sizeof(u32);
 
-	/* If we can map all of memory above page_offset, we do so. */
+	/* Ideally we map all physical memory starting at page_offset.
+	 * However, if page_offset is 0xC0000000 we can only map 1G of physical
+	 * (0xC0000000 + 1G overflows). */
 	if (mem <= -page_offset)
 		mapped_pages = mem/getpagesize();
 	else
 		mapped_pages = -page_offset/getpagesize();
 
-	/* Each linear PTE page can map ptes_per_page pages. */
+	/* Each PTE page can map ptes_per_page pages: how many do we need? */
 	linear_pages = (mapped_pages + ptes_per_page-1)/ptes_per_page;
 
-	/* We lay out top-level then linear mapping immediately below initrd */
+	/* We put the toplevel page directory page at the top of memory. */
 	pgdir = (void *)mem - initrd_size - getpagesize();
+
+	/* Now we use the next linear_pages pages as pte pages */
 	linear = (void *)pgdir - linear_pages*getpagesize();
 
+	/* Linear mapping is easy: put every page's address into the mapping in
+	 * order.  PAGE_PRESENT contains the flags Present, Writable and
+	 * Executable. */
 	for (i = 0; i < mapped_pages; i++)
 		linear[i] = ((i * getpagesize()) | PAGE_PRESENT);
 
-	/* Now set up pgd so that this memory is at page_offset */
+	/* The top level points to the linear page table pages above.  The
+	 * entry representing page_offset points to the first one, and they
+	 * continue from there. */
 	for (i = 0; i < mapped_pages; i += ptes_per_page) {
 		pgdir[(i + page_offset/getpagesize())/ptes_per_page]
 			= (((u32)linear + i*sizeof(u32)) | PAGE_PRESENT);
@@ -312,9 +476,13 @@ static unsigned long setup_pagetables(un
 	verbose("Linear mapping of %u pages in %u pte pages at %p\n",
 		mapped_pages, linear_pages, linear);
 
+	/* We return the top level (guest-physical) address: the kernel needs
+	 * to know where it is. */
 	return (unsigned long)pgdir;
 }
 
+/* Simple routine to roll all the commandline arguments together with spaces
+ * between them. */
 static void concat(char *dst, char *args[])
 {
 	unsigned int i, len = 0;
@@ -328,6 +496,10 @@ static void concat(char *dst, char *args
 	dst[len] = '\0';
 }
 
+/* This is where we actually tell the kernel to initialize the Guest.  We saw
+ * the arguments it expects when we looked at initialize() in lguest_user.c:
+ * the top physical page to allow, the top level pagetable, the entry point and
+ * the page_offset constant for the Guest. */
 static int tell_kernel(u32 pgdir, u32 start, u32 page_offset)
 {
 	u32 args[] = { LHREQ_INITIALIZE,
@@ -337,8 +509,11 @@ static int tell_kernel(u32 pgdir, u32 st
 	fd = open_or_die("/dev/lguest", O_RDWR);
 	if (write(fd, args, sizeof(args)) < 0)
 		err(1, "Writing to /dev/lguest");
+
+	/* We return the /dev/lguest file descriptor to control this Guest */
 	return fd;
 }
+/*:*/
 
 static void set_fd(int fd, struct device_list *devices)
 {
@@ -347,61 +522,108 @@ static void set_fd(int fd, struct device
 		devices->max_infd = fd;
 }
 
-/* When input arrives, we tell the kernel to kick lguest out with -EAGAIN. */
+/*L:200
+ * The Waker.
+ *
+ * With a console and network devices, we can have lots of input which we need
+ * to process.  We could try to tell the kernel what file descriptors to watch,
+ * but handing a file descriptor mask through to the kernel is fairly icky.
+ *
+ * Instead, we fork off a process which watches the file descriptors and writes
+ * the LHREQ_BREAK command to the /dev/lguest filedescriptor to tell the Host
+ * loop to stop running the Guest.  This causes it to return from the
+ * /dev/lguest read with -EAGAIN, where it will write to /dev/lguest to reset
+ * the LHREQ_BREAK and wake us up again.
+ *
+ * This, of course, is merely a different *kind* of icky.
+ */
 static void wake_parent(int pipefd, int lguest_fd, struct device_list *devices)
 {
+	/* Add the pipe from the Launcher to the fdset in the device_list, so
+	 * we watch it, too. */
 	set_fd(pipefd, devices);
 
 	for (;;) {
 		fd_set rfds = devices->infds;
 		u32 args[] = { LHREQ_BREAK, 1 };
 
+		/* Wait until input is ready from one of the devices. */
 		select(devices->max_infd+1, &rfds, NULL, NULL, NULL);
+		/* Is it a message from the Launcher? */
 		if (FD_ISSET(pipefd, &rfds)) {
 			int ignorefd;
+			/* If read() returns 0, it means the Launcher has
+			 * exited.  We silently follow. */
 			if (read(pipefd, &ignorefd, sizeof(ignorefd)) == 0)
 				exit(0);
+			/* Otherwise it's telling us there's a problem with one
+			 * of the devices, and we should ignore that file
+			 * descriptor from now on. */
 			FD_CLR(ignorefd, &devices->infds);
-		} else
+		} else /* Send LHREQ_BREAK command. */
 			write(lguest_fd, args, sizeof(args));
 	}
 }
 
+/* This routine just sets up a pipe to the Waker process. */
 static int setup_waker(int lguest_fd, struct device_list *device_list)
 {
 	int pipefd[2], child;
 
+	/* We create a pipe to talk to the waker, and also so it knows when the
+	 * Launcher dies (and closes pipe). */
 	pipe(pipefd);
 	child = fork();
 	if (child == -1)
 		err(1, "forking");
 
 	if (child == 0) {
+		/* Close the "writing" end of our copy of the pipe */
 		close(pipefd[1]);
 		wake_parent(pipefd[0], lguest_fd, device_list);
 	}
+	/* Close the reading end of our copy of the pipe. */
 	close(pipefd[0]);
 
+	/* Here is the fd used to talk to the waker. */
 	return pipefd[1];
 }
 
+/*L:210
+ * Device Handling.
+ *
+ * When the Guest sends DMA to us, it sends us an array of addresses and sizes.
+ * We need to make sure it's not trying to reach into the Launcher itself, so
+ * we have a convenient routine which check it and exits with an error message
+ * if something funny is going on:
+ */
 static void *_check_pointer(unsigned long addr, unsigned int size,
 			    unsigned int line)
 {
+	/* We have to separately check addr and addr+size, because size could
+	 * be huge and addr + size might wrap around. */
 	if (addr >= top || addr + size >= top)
 		errx(1, "%s:%i: Invalid address %li", __FILE__, line, addr);
+	/* We return a pointer for the caller's convenience, now we know it's
+	 * safe to use. */
 	return (void *)addr;
 }
+/* A macro which transparently hands the line number to the real function. */
 #define check_pointer(addr,size) _check_pointer(addr, size, __LINE__)
 
-/* Returns pointer to dma->used_len */
+/* The Guest has given us the address of a "struct lguest_dma".  We check it's
+ * OK and convert it to an iovec (which is a simple array of ptr/size
+ * pairs). */
 static u32 *dma2iov(unsigned long dma, struct iovec iov[], unsigned *num)
 {
 	unsigned int i;
 	struct lguest_dma *udma;
 
+	/* First we make sure that the array memory itself is valid. */
 	udma = check_pointer(dma, sizeof(*udma));
+	/* Now we check each element */
 	for (i = 0; i < LGUEST_MAX_DMA_SECTIONS; i++) {
+		/* A zero length ends the array. */
 		if (!udma->len[i])
 			break;
 
@@ -409,9 +631,15 @@ static u32 *dma2iov(unsigned long dma, s
 		iov[i].iov_len = udma->len[i];
 	}
 	*num = i;
+
+	/* We return the pointer to where the caller should write the amount of
+	 * the buffer used. */
 	return &udma->used_len;
 }
 
+/* This routine gets a DMA buffer from the Guest for a given key, and converts
+ * it to an iovec array.  It returns the interrupt the Guest wants when we're
+ * finished, and a pointer to the "used_len" field to fill in. */
 static u32 *get_dma_buffer(int fd, void *key,
 			   struct iovec iov[], unsigned int *num, u32 *irq)
 {
@@ -419,16 +647,21 @@ static u32 *get_dma_buffer(int fd, void 
 	unsigned long udma;
 	u32 *res;
 
+	/* Ask the kernel for a DMA buffer corresponding to this key. */
 	udma = write(fd, buf, sizeof(buf));
+	/* They haven't registered any, or they're all used? */
 	if (udma == (unsigned long)-1)
 		return NULL;
 
-	/* Kernel stashes irq in ->used_len. */
+	/* Convert it into our iovec array */
 	res = dma2iov(udma, iov, num);
+	/* The kernel stashes irq in ->used_len to get it out to us. */
 	*irq = *res;
+	/* Return a pointer to ((struct lguest_dma *)udma)->used_len. */
 	return res;
 }
 
+/* This is a convenient routine to send the Guest an interrupt. */
 static void trigger_irq(int fd, u32 irq)
 {
 	u32 buf[] = { LHREQ_IRQ, irq };
@@ -436,6 +669,10 @@ static void trigger_irq(int fd, u32 irq)
 		err(1, "Triggering irq %i", irq);
 }
 
+/* This simply sets up an iovec array where we can put data to be discarded.
+ * This happens when the Guest doesn't want or can't handle the input: we have
+ * to get rid of it somewhere, and if we bury it in the ceiling space it will
+ * start to smell after a week. */
 static void discard_iovec(struct iovec *iov, unsigned int *num)
 {
 	static char discard_buf[1024];
@@ -444,19 +681,24 @@ static void discard_iovec(struct iovec *
 	iov->iov_len = sizeof(discard_buf);
 }
 
+/* Here is the input terminal setting we save, and the routine to restore them
+ * on exit so the user can see what they type next. */
 static struct termios orig_term;
 static void restore_term(void)
 {
 	tcsetattr(STDIN_FILENO, TCSANOW, &orig_term);
 }
 
+/* We associate some data with the console for our exit hack. */
 struct console_abort
 {
+	/* How many times have they hit ^C? */
 	int count;
+	/* When did they start? */
 	struct timeval start;
 };
 
-/* We DMA input to buffer bound at start of console page. */
+/* This is the routine which handles console input (ie. stdin). */
 static bool handle_console_input(int fd, struct device *dev)
 {
 	u32 irq = 0, *lenp;
@@ -465,24 +707,38 @@ static bool handle_console_input(int fd,
 	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
 	struct console_abort *abort = dev->priv;
 
+	/* First we get the console buffer from the Guest.  The key is dev->mem
+	 * which was set to 0 in setup_console(). */
 	lenp = get_dma_buffer(fd, dev->mem, iov, &num, &irq);
 	if (!lenp) {
+		/* If it's not ready for input, warn and set up to discard. */
 		warn("console: no dma buffer!");
 		discard_iovec(iov, &num);
 	}
 
+	/* This is why we convert to iovecs: the readv() call uses them, and so
+	 * it reads straight into the Guest's buffer. */
 	len = readv(dev->fd, iov, num);
 	if (len <= 0) {
+		/* This implies that the console is closed, is /dev/null, or
+		 * something went terribly wrong.  We still go through the rest
+		 * of the logic, though, especially the exit handling below. */
 		warnx("Failed to get console input, ignoring console.");
 		len = 0;
 	}
 
+	/* If we read the data into the Guest, fill in the length and send the
+	 * interrupt. */
 	if (lenp) {
 		*lenp = len;
 		trigger_irq(fd, irq);
 	}
 
-	/* Three ^C within one second?  Exit. */
+	/* Three ^C within one second?  Exit.
+	 *
+	 * This is such a hack, but works surprisingly well.  Each ^C has to be
+	 * in a buffer by itself, so they can't be too fast.  But we check that
+	 * we get three within about a second, so they can't be too slow. */
 	if (len == 1 && ((char *)iov[0].iov_base)[0] == 3) {
 		if (!abort->count++)
 			gettimeofday(&abort->start, NULL);
@@ -490,43 +746,60 @@ static bool handle_console_input(int fd,
 			struct timeval now;
 			gettimeofday(&now, NULL);
 			if (now.tv_sec <= abort->start.tv_sec+1) {
-				/* Make sure waker is not blocked in BREAK */
 				u32 args[] = { LHREQ_BREAK, 0 };
+				/* Close the fd so Waker will know it has to
+				 * exit. */
 				close(waker_fd);
+				/* Just in case waker is blocked in BREAK, send
+				 * unbreak now. */
 				write(fd, args, sizeof(args));
 				exit(2);
 			}
 			abort->count = 0;
 		}
 	} else
+		/* Any other key resets the abort counter. */
 		abort->count = 0;
 
+	/* Now, if we didn't read anything, put the input terminal back and
+	 * return failure (meaning, don't call us again). */
 	if (!len) {
 		restore_term();
 		return false;
 	}
+	/* Everything went OK! */
 	return true;
 }
 
+/* Handling console output is much simpler than input. */
 static u32 handle_console_output(int fd, const struct iovec *iov,
 				 unsigned num, struct device*dev)
 {
+	/* Whatever the Guest sends, write it to standard output.  Return the
+	 * number of bytes written. */
 	return writev(STDOUT_FILENO, iov, num);
 }
 
+/* Guest->Host network output is also pretty easy. */
 static u32 handle_tun_output(int fd, const struct iovec *iov,
 			     unsigned num, struct device *dev)
 {
-	/* Now we've seen output, we should warn if we can't get buffers. */
+	/* We put a flag in the "priv" pointer of the network device, and set
+	 * it as soon as we see output.  We'll see why in handle_tun_input() */
 	*(bool *)dev->priv = true;
+	/* Whatever packet the Guest sent us, write it out to the tun
+	 * device. */
 	return writev(dev->fd, iov, num);
 }
 
+/* This matches the peer_key() in lguest_net.c.  The key for any given slot
+ * is the address of the network device's page plus 4 * the slot number. */
 static unsigned long peer_offset(unsigned int peernum)
 {
 	return 4 * peernum;
 }
 
+/* This is where we handle a packet coming in from the tun device */
 static bool handle_tun_input(int fd, struct device *dev)
 {
 	u32 irq = 0, *lenp;
@@ -534,17 +807,28 @@ static bool handle_tun_input(int fd, str
 	unsigned num;
 	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
 
+	/* First we get a buffer the Guest has bound to its key. */
 	lenp = get_dma_buffer(fd, dev->mem+peer_offset(NET_PEERNUM), iov, &num,
 			      &irq);
 	if (!lenp) {
+		/* Now, it's expected that if we try to send a packet too
+		 * early, the Guest won't be ready yet.  This is why we set a
+		 * flag when the Guest sends its first packet.  If it's sent a
+		 * packet we assume it should be ready to receive them.
+		 *
+		 * Actually, this is what the status bits in the descriptor are
+		 * for: we should *use* them.  FIXME! */
 		if (*(bool *)dev->priv)
 			warn("network: no dma buffer!");
 		discard_iovec(iov, &num);
 	}
 
+	/* Read the packet from the device directly into the Guest's buffer. */
 	len = readv(dev->fd, iov, num);
 	if (len <= 0)
 		err(1, "reading network");
+
+	/* Write the used_len, and trigger the interrupt for the Guest */
 	if (lenp) {
 		*lenp = len;
 		trigger_irq(fd, irq);
@@ -552,9 +836,13 @@ static bool handle_tun_input(int fd, str
 	verbose("tun input packet len %i [%02x %02x] (%s)\n", len,
 		((u8 *)iov[0].iov_base)[0], ((u8 *)iov[0].iov_base)[1],
 		lenp ? "sent" : "discarded");
+	/* All good. */
 	return true;
 }
 
+/* The last device handling routine is block output: the Guest has sent a DMA
+ * to the block device.  It will have placed the command it wants in the
+ * "struct lguest_block_page". */
 static u32 handle_block_output(int fd, const struct iovec *iov,
 			       unsigned num, struct device *dev)
 {
@@ -564,36 +852,64 @@ static u32 handle_block_output(int fd, c
 	struct iovec reply[LGUEST_MAX_DMA_SECTIONS];
 	off64_t device_len, off = (off64_t)p->sector * 512;
 
+	/* First we extract the device length from the dev->priv pointer. */
 	device_len = *(off64_t *)dev->priv;
 
+	/* We first check that the read or write is within the length of the
+	 * block file. */
 	if (off >= device_len)
 		err(1, "Bad offset %llu vs %llu", off, device_len);
+	/* Move to the right location in the block file.  This shouldn't fail,
+	 * but best to check. */
 	if (lseek64(dev->fd, off, SEEK_SET) != off)
 		err(1, "Bad seek to sector %i", p->sector);
 
 	verbose("Block: %s at offset %llu\n", p->type ? "WRITE" : "READ", off);
 
+	/* They were supposed to bind a reply buffer at key equal to the start
+	 * of the block device memory.  We need this to tell them when the
+	 * request is finished. */
 	lenp = get_dma_buffer(fd, dev->mem, reply, &reply_num, &irq);
 	if (!lenp)
 		err(1, "Block request didn't give us a dma buffer");
 
 	if (p->type) {
+		/* A write request.  The DMA they sent contained the data, so
+		 * write it out. */
 		len = writev(dev->fd, iov, num);
+		/* Grr... Now we know how long the "struct lguest_dma" they
+		 * sent was, we make sure they didn't try to write over the end
+		 * of the block file (possibly extending it). */
 		if (off + len > device_len) {
+			/* Trim it back to the correct length */
 			ftruncate(dev->fd, device_len);
+			/* Die, bad Guest, die. */
 			errx(1, "Write past end %llu+%u", off, len);
 		}
+		/* The reply length is 0: we just send back an empty DMA to
+		 * interrupt them and tell them the write is finished. */
 		*lenp = 0;
 	} else {
+		/* A read request.  They sent an empty DMA to start the
+		 * request, and we put the read contents into the reply
+		 * buffer. */
 		len = readv(dev->fd, reply, reply_num);
 		*lenp = len;
 	}
 
+	/* The result is 1 (done), 2 if there was an error (short read or
+	 * write). */
 	p->result = 1 + (p->bytes != len);
+	/* Now tell them we've used their reply buffer. */
 	trigger_irq(fd, irq);
+
+	/* We're supposed to return the number of bytes of the output buffer we
+	 * used.  But the block device uses the "result" field instead, so we
+	 * don't bother. */
 	return 0;
 }
 
+/* This is the generic routine we call when the Guest sends some DMA out. */
 static void handle_output(int fd, unsigned long dma, unsigned long key,
 			  struct device_list *devices)
 {
@@ -602,30 +918,53 @@ static void handle_output(int fd, unsign
 	struct iovec iov[LGUEST_MAX_DMA_SECTIONS];
 	unsigned num = 0;
 
+	/* Convert the "struct lguest_dma" they're sending to a "struct
+	 * iovec". */
 	lenp = dma2iov(dma, iov, &num);
+
+	/* Check each device: if they expect output to this key, tell them to
+	 * handle it. */
 	for (i = devices->dev; i; i = i->next) {
 		if (i->handle_output && key == i->watch_key) {
+			/* We write the result straight into the used_len field
+			 * for them. */
 			*lenp = i->handle_output(fd, iov, num, i);
 			return;
 		}
 	}
+
+	/* This can happen: the kernel sends any SEND_DMA which doesn't match
+	 * another Guest to us.  It could be that another Guest just left a
+	 * network, for example.  But it's unusual. */
 	warnx("Pending dma %p, key %p", (void *)dma, (void *)key);
 }
 
+/* This is called when the waker wakes us up: check for incoming file
+ * descriptors. */
 static void handle_input(int fd, struct device_list *devices)
 {
+	/* select() wants a zeroed timeval to mean "don't wait". */
 	struct timeval poll = { .tv_sec = 0, .tv_usec = 0 };
 
 	for (;;) {
 		struct device *i;
 		fd_set fds = devices->infds;
 
+		/* If nothing is ready, we're done. */
 		if (select(devices->max_infd+1, &fds, NULL, NULL, &poll) == 0)
 			break;
 
+		/* Otherwise, call the device(s) which have readable
+		 * file descriptors and a method of handling them.  */
 		for (i = devices->dev; i; i = i->next) {
 			if (i->handle_input && FD_ISSET(i->fd, &fds)) {
+				/* If handle_input() returns false, it means we
+				 * should no longer service it.
+				 * handle_console_input() does this. */
 				if (!i->handle_input(fd, i)) {
+					/* Clear it from the set of input file
+					 * descriptors kept at the head of the
+					 * device list. */
 					FD_CLR(i->fd, &devices->infds);
 					/* Tell waker to ignore it too... */
 					write(waker_fd, &i->fd, sizeof(i->fd));
@@ -635,6 +974,15 @@ static void handle_input(int fd, struct 
 	}
 }
 
+/*L:190
+ * Device Setup
+ *
+ * All devices need a descriptor so the Guest knows it exists, and a "struct
+ * device" so the Launcher can keep track of it.  We have common helper
+ * routines to allocate them.
+ *
+ * This routine allocates a new "struct lguest_device_desc" from descriptor
+ * table in the devices array just above the Guest's normal memory. */
 static struct lguest_device_desc *
 new_dev_desc(struct lguest_device_desc *descs,
 	     u16 type, u16 features, u16 num_pages)
@@ -646,6 +994,8 @@ new_dev_desc(struct lguest_device_desc *
 			descs[i].type = type;
 			descs[i].features = features;
 			descs[i].num_pages = num_pages;
+			/* If they said the device needs memory, we allocate
+			 * that now, bumping up the top of Guest memory. */
 			if (num_pages) {
 				map_zeroed_pages(top, num_pages);
 				descs[i].pfn = top/getpagesize();
@@ -657,6 +1007,9 @@ new_dev_desc(struct lguest_device_desc *
 	errx(1, "too many devices");
 }
 
+/* This monster routine does all the creation and setup of a new device,
+ * including caling new_dev_desc() to allocate the descriptor and device
+ * memory. */
 static struct device *new_device(struct device_list *devices,
 				 u16 type, u16 num_pages, u16 features,
 				 int fd,
@@ -669,12 +1022,18 @@ static struct device *new_device(struct 
 {
 	struct device *dev = malloc(sizeof(*dev));
 
-	/* Append to device list. */
+	/* Append to device list.  Prepending to a single-linked list is
+	 * easier, but the user expects the devices to be arranged on the bus
+	 * in command-line order.  The first network device on the command line
+	 * is eth0, the first block device /dev/lgba, etc. */
 	*devices->lastdev = dev;
 	dev->next = NULL;
 	devices->lastdev = &dev->next;
 
+	/* Now we populate the fields one at a time. */
 	dev->fd = fd;
+	/* If we have an input handler for this file descriptor, then we add it
+	 * to the device_list's fdset and maxfd. */
 	if (handle_input)
 		set_fd(dev->fd, devices);
 	dev->desc = new_dev_desc(devices->descs, type, features, num_pages);
@@ -685,27 +1044,37 @@ static struct device *new_device(struct 
 	return dev;
 }
 
+/* Our first setup routine is the console.  It's a fairly simple device, but
+ * UNIX tty handling makes it uglier than it could be. */
 static void setup_console(struct device_list *devices)
 {
 	struct device *dev;
 
+	/* If we can save the initial standard input settings... */
 	if (tcgetattr(STDIN_FILENO, &orig_term) == 0) {
 		struct termios term = orig_term;
+		/* Then we turn off echo, line buffering and ^C etc.  We want a
+		 * raw input stream to the Guest. */
 		term.c_lflag &= ~(ISIG|ICANON|ECHO);
 		tcsetattr(STDIN_FILENO, TCSANOW, &term);
+		/* If we exit gracefully, the original settings will be
+		 * restored so the user can see what they're typing. */
 		atexit(restore_term);
 	}
 
-	/* We don't currently require a page for the console. */
+	/* We don't currently require any memory for the console, so we ask for
+	 * 0 pages. */
 	dev = new_device(devices, LGUEST_DEVICE_T_CONSOLE, 0, 0,
 			 STDIN_FILENO, handle_console_input,
 			 LGUEST_CONSOLE_DMA_KEY, handle_console_output);
+	/* We store the console state in dev->priv, and initialize it. */
 	dev->priv = malloc(sizeof(struct console_abort));
 	((struct console_abort *)dev->priv)->count = 0;
 	verbose("device %p: console\n",
 		(void *)(dev->desc->pfn * getpagesize()));
 }
 
+/* Setting up a block file is also fairly straightforward. */
 static void setup_block_file(const char *filename, struct device_list *devices)
 {
 	int fd;
@@ -713,20 +1082,47 @@ static void setup_block_file(const char 
 	off64_t *device_len;
 	struct lguest_block_page *p;
 
+	/* We open with O_LARGEFILE because otherwise we get stuck at 2G.  We
+	 * open with O_DIRECT because otherwise our benchmarks go much too
+	 * fast. */
 	fd = open_or_die(filename, O_RDWR|O_LARGEFILE|O_DIRECT);
+
+	/* We want one page, and have no input handler (the block file never
+	 * has anything interesting to say to us).  Our timing will be quite
+	 * random, so it should be a reasonable randomness source. */
 	dev = new_device(devices, LGUEST_DEVICE_T_BLOCK, 1,
 			 LGUEST_DEVICE_F_RANDOMNESS,
 			 fd, NULL, 0, handle_block_output);
+
+	/* We store the device size in the private area */
 	device_len = dev->priv = malloc(sizeof(*device_len));
+	/* This is the safe way of establishing the size of our device: it
+	 * might be a normal file or an actual block device like /dev/hdb. */
 	*device_len = lseek64(fd, 0, SEEK_END);
-	p = dev->mem;
 
+	/* The device memory is a "struct lguest_block_page".  It's zeroed
+	 * already, we just need to put in the device size.  Block devices
+	 * think in sectors (ie. 512 byte chunks), so we translate here. */
+	p = dev->mem;
 	p->num_sectors = *device_len/512;
 	verbose("device %p: block %i sectors\n",
 		(void *)(dev->desc->pfn * getpagesize()), p->num_sectors);
 }
 
-/* We use fnctl locks to reserve network slots (autocleanup!) */
+/*
+ * Network Devices.
+ *
+ * Setting up network devices is quite a pain, because we have three types.
+ * First, we have the inter-Guest network.  This is a file which is mapped into
+ * the address space of the Guests who are on the network.  Because it is a
+ * shared mapping, the same page underlies all the devices, and they can send
+ * DMA to each other.
+ *
+ * Remember from our network driver, the Guest is told what slot in the page it
+ * is to use.  We use exclusive fnctl locks to reserve a slot.  If another
+ * Guest is using a slot, the lock will fail and we try another.  Because fnctl
+ * locks are cleaned up automatically when we die, this cleverly means that our
+ * reservation on the slot will vanish if we crash. */
 static unsigned int find_slot(int netfd, const char *filename)
 {
 	struct flock fl;
@@ -734,26 +1130,33 @@ static unsigned int find_slot(int netfd,
 	fl.l_type = F_WRLCK;
 	fl.l_whence = SEEK_SET;
 	fl.l_len = 1;
+	/* Try a 1 byte lock in each possible position number */
 	for (fl.l_start = 0;
 	     fl.l_start < getpagesize()/sizeof(struct lguest_net);
 	     fl.l_start++) {
+		/* If we succeed, return the slot number. */
 		if (fcntl(netfd, F_SETLK, &fl) == 0)
 			return fl.l_start;
 	}
 	errx(1, "No free slots in network file %s", filename);
 }
 
+/* This function sets up the network file */
 static void setup_net_file(const char *filename,
 			   struct device_list *devices)
 {
 	int netfd;
 	struct device *dev;
 
+	/* We don't use open_or_die() here: for friendliness we create the file
+	 * if it doesn't already exist. */
 	netfd = open(filename, O_RDWR, 0);
 	if (netfd < 0) {
 		if (errno == ENOENT) {
 			netfd = open(filename, O_RDWR|O_CREAT, 0600);
 			if (netfd >= 0) {
+				/* If we succeeded, initialize the file with a
+				 * blank page. */
 				char page[getpagesize()];
 				memset(page, 0, sizeof(page));
 				write(netfd, page, sizeof(page));
@@ -763,11 +1166,15 @@ static void setup_net_file(const char *f
 			err(1, "cannot open net file '%s'", filename);
 	}
 
+	/* We need 1 page, and the features indicate the slot to use and that
+	 * no checksum is needed.  We never touch this device again; it's
+	 * between the Guests on the network, so we don't register input or
+	 * output handlers. */
 	dev = new_device(devices, LGUEST_DEVICE_T_NET, 1,
 			 find_slot(netfd, filename)|LGUEST_NET_F_NOCSUM,
 			 -1, NULL, 0, NULL);
 
-	/* We overwrite the /dev/zero mapping with the actual file. */
+	/* Map the shared file. */
 	if (mmap(dev->mem, getpagesize(), PROT_READ|PROT_WRITE,
 			 MAP_FIXED|MAP_SHARED, netfd, 0) != dev->mem)
 			err(1, "could not mmap '%s'", filename);
@@ -775,6 +1182,7 @@ static void setup_net_file(const char *f
 		(void *)(dev->desc->pfn * getpagesize()), filename,
 		dev->desc->features & ~LGUEST_NET_F_NOCSUM);
 }
+/*:*/
 
 static u32 str2ip(const char *ipaddr)
 {
@@ -784,7 +1192,11 @@ static u32 str2ip(const char *ipaddr)
 	return (byte[0] << 24) | (byte[1] << 16) | (byte[2] << 8) | byte[3];
 }
 
-/* adapted from libbridge */
+/* This code is "adapted" from libbridge: it attaches the Host end of the
+ * network device to the bridge device specified by the command line.
+ *
+ * This is yet another James Morris contribution (I'm an IP-level guy, so I
+ * dislike bridging), and I just try not to break it. */
 static void add_to_bridge(int fd, const char *if_name, const char *br_name)
 {
 	int ifidx;
@@ -803,12 +1215,16 @@ static void add_to_bridge(int fd, const 
 		err(1, "can't add %s to bridge %s", if_name, br_name);
 }
 
+/* This sets up the Host end of the network device with an IP address, brings
+ * it up so packets will flow, the copies the MAC address into the hwaddr
+ * pointer (in practice, the Host's slot in the network device's memory). */
 static void configure_device(int fd, const char *devname, u32 ipaddr,
 			     unsigned char hwaddr[6])
 {
 	struct ifreq ifr;
 	struct sockaddr_in *sin = (struct sockaddr_in *)&ifr.ifr_addr;
 
+	/* Don't read these incantations.  Just cut & paste them like I did! */
 	memset(&ifr, 0, sizeof(ifr));
 	strcpy(ifr.ifr_name, devname);
 	sin->sin_family = AF_INET;
@@ -819,12 +1235,19 @@ static void configure_device(int fd, con
 	if (ioctl(fd, SIOCSIFFLAGS, &ifr) != 0)
 		err(1, "Bringing interface %s up", devname);
 
+	/* SIOC stands for Socket I/O Control.  G means Get (vs S for Set
+	 * above).  IF means Interface, and HWADDR is hardware address.
+	 * Simple! */
 	if (ioctl(fd, SIOCGIFHWADDR, &ifr) != 0)
 		err(1, "getting hw address for %s", devname);
-
 	memcpy(hwaddr, ifr.ifr_hwaddr.sa_data, 6);
 }
 
+/*L:195 The other kind of network is a Host<->Guest network.  This can either
+ * use briding or routing, but the principle is the same: it uses the "tun"
+ * device to inject packets into the Host as if they came in from a normal
+ * network card.  We just shunt packets between the Guest and the tun
+ * device. */
 static void setup_tun_net(const char *arg, struct device_list *devices)
 {
 	struct device *dev;
@@ -833,36 +1256,56 @@ static void setup_tun_net(const char *ar
 	u32 ip;
 	const char *br_name = NULL;
 
+	/* We open the /dev/net/tun device and tell it we want a tap device.  A
+	 * tap device is like a tun device, only somehow different.  To tell
+	 * the truth, I completely blundered my way through this code, but it
+	 * works now! */
 	netfd = open_or_die("/dev/net/tun", O_RDWR);
 	memset(&ifr, 0, sizeof(ifr));
 	ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
 	strcpy(ifr.ifr_name, "tap%d");
 	if (ioctl(netfd, TUNSETIFF, &ifr) != 0)
 		err(1, "configuring /dev/net/tun");
+	/* We don't need checksums calculated for packets coming in this
+	 * device: trust us! */
 	ioctl(netfd, TUNSETNOCSUM, 1);
 
-	/* You will be peer 1: we should create enough jitter to randomize */
+	/* We create the net device with 1 page, using the features field of
+	 * the descriptor to tell the Guest it is in slot 1 (NET_PEERNUM), and
+	 * that the device has fairly random timing.  We do *not* specify
+	 * LGUEST_NET_F_NOCSUM: these packets can reach the real world.
+	 *
+	 * We will put our MAC address is slot 0 for the Guest to see, so
+	 * it will send packets to us using the key "peer_offset(0)": */
 	dev = new_device(devices, LGUEST_DEVICE_T_NET, 1,
 			 NET_PEERNUM|LGUEST_DEVICE_F_RANDOMNESS, netfd,
 			 handle_tun_input, peer_offset(0), handle_tun_output);
+
+	/* We keep a flag which says whether we've seen packets come out from
+	 * this network device. */
 	dev->priv = malloc(sizeof(bool));
 	*(bool *)dev->priv = false;
 
+	/* We need a socket to perform the magic network ioctls to bring up the
+	 * tap interface, connect to the bridge etc.  Any socket will do! */
 	ipfd = socket(PF_INET, SOCK_DGRAM, IPPROTO_IP);
 	if (ipfd < 0)
 		err(1, "opening IP socket");
 
+	/* If the command line was --tunnet=bridge:<name> do bridging. */
 	if (!strncmp(BRIDGE_PFX, arg, strlen(BRIDGE_PFX))) {
 		ip = INADDR_ANY;
 		br_name = arg + strlen(BRIDGE_PFX);
 		add_to_bridge(ipfd, ifr.ifr_name, br_name);
-	} else
+	} else /* It is an IP address to set up the device with */
 		ip = str2ip(arg);
 
-	/* We are peer 0, ie. first slot. */
+	/* We are peer 0, ie. first slot, so we hand dev->mem to this routine
+	 * to write the MAC address at the start of the device memory.  */
 	configure_device(ipfd, ifr.ifr_name, ip, dev->mem);
 
-	/* Set "promisc" bit: we want every single packet. */
+	/* Set "promisc" bit: we want every single packet if we're going to
+	 * bridge to other machines (and otherwise it doesn't matter). */
 	*((u8 *)dev->mem) |= 0x1;
 
 	close(ipfd);
@@ -873,7 +1316,10 @@ static void setup_tun_net(const char *ar
 	if (br_name)
 		verbose("attached to bridge: %s\n", br_name);
 }
+/* That's the end of device setup. */
 
+/*L:220 Finally we reach the core of the Launcher, which runs the Guest, serves
+ * its input and output, and finally, lays it to rest. */
 static void __attribute__((noreturn))
 run_guest(int lguest_fd, struct device_list *device_list)
 {
@@ -885,20 +1331,37 @@ run_guest(int lguest_fd, struct device_l
 		/* We read from the /dev/lguest device to run the Guest. */
 		readval = read(lguest_fd, arr, sizeof(arr));
 
+		/* The read can only really return sizeof(arr) (the Guest did a
+		 * SEND_DMA to us), or an error. */
+
+		/* For a successful read, arr[0] is the address of the "struct
+		 * lguest_dma", and arr[1] is the key the Guest sent to. */
 		if (readval == sizeof(arr)) {
 			handle_output(lguest_fd, arr[0], arr[1], device_list);
 			continue;
+		/* ENOENT means the Guest died.  Reading tells us why. */
 		} else if (errno == ENOENT) {
 			char reason[1024] = { 0 };
 			read(lguest_fd, reason, sizeof(reason)-1);
 			errx(1, "%s", reason);
+		/* EAGAIN means the waker wanted us to look at some input.
+		 * Anything else means a bug or incompatible change. */
 		} else if (errno != EAGAIN)
 			err(1, "Running guest failed");
+
+		/* Service input, then unset the BREAK which releases
+		 * the Waker. */
 		handle_input(lguest_fd, device_list);
 		if (write(lguest_fd, args, sizeof(args)) < 0)
 			err(1, "Resetting break");
 	}
 }
+/*
+ * This is the end of the Launcher.
+ *
+ * But wait!  We've seen I/O from the Launcher, and we've seen I/O from the
+ * Drivers.  If we were to see the Host kernel I/O code, our understanding
+ * would be complete... :*/
 
 static struct option opts[] = {
 	{ "verbose", 0, NULL, 'v' },
@@ -916,20 +1379,49 @@ static void usage(void)
 	     "<mem-in-mb> vmlinux [args...]");
 }
 
+/*L:100 The Launcher code itself takes us out into userspace, that scary place
+ * where pointers run wild and free!  Unfortunately, like most userspace
+ * programs, it's quite boring (which is why everyone like to hack on the
+ * kernel!).  Perhaps if you make up an Lguest Drinking Game at this point, it
+ * will get you through this section.  Or, maybe not.
+ *
+ * The Launcher binary sits up high, usually starting at address 0xB8000000.
+ * Everything below this is the "physical" memory for the Guest.  For example,
+ * if the Guest were to write a "1" at physical address 0, we would see a "1"
+ * in the Launcher at "(int *)0".  Guest physical == Launcher virtual.
+ *
+ * This can be tough to get your head around, but usually it just means that we
+ * don't need to do any conversion when the Guest gives us it's "physical"
+ * addresses.
+ */
 int main(int argc, char *argv[])
 {
+	/* Memory, top-level pagetable, code startpoint, PAGE_OFFSET and size
+	 * of the (optional) initrd. */
 	unsigned long mem = 0, pgdir, start, page_offset, initrd_size = 0;
+	/* A temporary and the /dev/lguest file descriptor. */
 	int i, c, lguest_fd;
+	/* The list of Guest devices, based on command line arguments. */
 	struct device_list device_list;
+	/* The boot information for the Guest: at guest-physical address 0. */
 	void *boot = (void *)0;
+	/* If they specify an initrd file to load. */
 	const char *initrd_name = NULL;
 
+	/* First we initialize the device list.  Since console and network
+	 * device receive input from a file descriptor, we keep an fdset
+	 * (infds) and the maximum fd number (max_infd) with the head of the
+	 * list.  We also keep a pointer to the last device, for easy appending
+	 * to the list. */
 	device_list.max_infd = -1;
 	device_list.dev = NULL;
 	device_list.lastdev = &device_list.dev;
 	FD_ZERO(&device_list.infds);
 
-	/* We need to know how much memory so we can allocate devices. */
+	/* We need to know how much memory so we can set up the device
+	 * descriptor and memory pages for the devices as we parse the command
+	 * line.  So we quickly look through the arguments to find the amount
+	 * of memory now. */
 	for (i = 1; i < argc; i++) {
 		if (argv[i][0] != '-') {
 			mem = top = atoi(argv[i]) * 1024 * 1024;
@@ -938,6 +1430,8 @@ int main(int argc, char *argv[])
 			break;
 		}
 	}
+
+	/* The options are fairly straight-forward */
 	while ((c = getopt_long(argc, argv, "v", opts, NULL)) != EOF) {
 		switch (c) {
 		case 'v':
@@ -960,42 +1454,59 @@ int main(int argc, char *argv[])
 			usage();
 		}
 	}
+	/* After the other arguments we expect memory and kernel image name,
+	 * followed by command line arguments for the kernel. */
 	if (optind + 2 > argc)
 		usage();
 
-	/* We need a console device */
+	/* We always have a console device */
 	setup_console(&device_list);
 
-	/* First we map /dev/zero over all of guest-physical memory. */
+	/* We start by mapping anonymous pages over all of guest-physical
+	 * memory range.  This fills it with 0, and ensures that the Guest
+	 * won't be killed when it tries to access it. */
 	map_zeroed_pages(0, mem / getpagesize());
 
 	/* Now we load the kernel */
 	start = load_kernel(open_or_die(argv[optind+1], O_RDONLY),
 			    &page_offset);
 
-	/* Map the initrd image if requested */
+	/* Map the initrd image if requested (at top of physical memory) */
 	if (initrd_name) {
 		initrd_size = load_initrd(initrd_name, mem);
+		/* These are the location in the Linux boot header where the
+		 * start and size of the initrd are expected to be found. */
 		*(unsigned long *)(boot+0x218) = mem - initrd_size;
 		*(unsigned long *)(boot+0x21c) = initrd_size;
+		/* The bootloader type 0xFF means "unknown"; that's OK. */
 		*(unsigned char *)(boot+0x210) = 0xFF;
 	}
 
-	/* Set up the initial linar pagetables. */
+	/* Set up the initial linear pagetables, starting below the initrd. */
 	pgdir = setup_pagetables(mem, initrd_size, page_offset);
 
-	/* E820 memory map: ours is a simple, single region. */
+	/* The Linux boot header contains an "E820" memory map: ours is a
+	 * simple, single region. */
 	*(char*)(boot+E820NR) = 1;
 	*((struct e820entry *)(boot+E820MAP))
 		= ((struct e820entry) { 0, mem, E820_RAM });
-	/* Command line pointer and command line (at 4096) */
+	/* The boot header contains a command line pointer: we put the command
+	 * line after the boot header (at address 4096) */
 	*(void **)(boot + 0x228) = boot + 4096;
 	concat(boot + 4096, argv+optind+2);
-	/* Paravirt type: 1 == lguest */
+
+	/* The guest type value of "1" tells the Guest it's under lguest. */
 	*(int *)(boot + 0x23c) = 1;
 
+	/* We tell the kernel to initialize the Guest: this returns the open
+	 * /dev/lguest file descriptor. */
 	lguest_fd = tell_kernel(pgdir, start, page_offset);
+
+	/* We fork off a child process, which wakes the Launcher whenever one
+	 * of the input file descriptors needs attention.  Otherwise we would
+	 * run the Guest until it tries to output something. */
 	waker_fd = setup_waker(lguest_fd, &device_list);
 
+	/* Finally, run the Guest.  This doesn't return. */
 	run_guest(lguest_fd, &device_list);
 }
diff -puN drivers/lguest/core.c~lguest-documentation-iv-launcher drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-documentation-iv-launcher
+++ a/drivers/lguest/core.c
@@ -208,24 +208,39 @@ static int emulate_insn(struct lguest *l
 	return 1;
 }
 
+/*L:305
+ * Dealing With Guest Memory.
+ *
+ * When the Guest gives us (what it thinks is) a physical address, we can use
+ * the normal copy_from_user() & copy_to_user() on that address: remember,
+ * Guest physical == Launcher virtual.
+ *
+ * But we can't trust the Guest: it might be trying to access the Launcher
+ * code.  We have to check that the range is below the pfn_limit the Launcher
+ * gave us.  We have to make sure that addr + len doesn't give us a false
+ * positive by overflowing, too. */
 int lguest_address_ok(const struct lguest *lg,
 		      unsigned long addr, unsigned long len)
 {
 	return (addr+len) / PAGE_SIZE < lg->pfn_limit && (addr+len >= addr);
 }
 
-/* Just like get_user, but don't let guest access lguest binary. */
+/* This is a convenient routine to get a 32-bit value from the Guest (a very
+ * common operation).  Here we can see how useful the kill_lguest() routine we
+ * met in the Launcher can be: we return a random value (0) instead of needing
+ * to return an error. */
 u32 lgread_u32(struct lguest *lg, unsigned long addr)
 {
 	u32 val = 0;
 
-	/* Don't let them access lguest binary */
+	/* Don't let them access lguest binary. */
 	if (!lguest_address_ok(lg, addr, sizeof(val))
 	    || get_user(val, (u32 __user *)addr) != 0)
 		kill_guest(lg, "bad read address %#lx", addr);
 	return val;
 }
 
+/* Same thing for writing a value. */
 void lgwrite_u32(struct lguest *lg, unsigned long addr, u32 val)
 {
 	if (!lguest_address_ok(lg, addr, sizeof(val))
@@ -233,6 +248,9 @@ void lgwrite_u32(struct lguest *lg, unsi
 		kill_guest(lg, "bad write address %#lx", addr);
 }
 
+/* This routine is more generic, and copies a range of Guest bytes into a
+ * buffer.  If the copy_from_user() fails, we fill the buffer with zeroes, so
+ * the caller doesn't end up using uninitialized kernel memory. */
 void lgread(struct lguest *lg, void *b, unsigned long addr, unsigned bytes)
 {
 	if (!lguest_address_ok(lg, addr, bytes)
@@ -243,6 +261,7 @@ void lgread(struct lguest *lg, void *b, 
 	}
 }
 
+/* Similarly, our generic routine to copy into a range of Guest bytes. */
 void lgwrite(struct lguest *lg, unsigned long addr, const void *b,
 	     unsigned bytes)
 {
@@ -250,6 +269,7 @@ void lgwrite(struct lguest *lg, unsigned
 	    || copy_to_user((void __user *)addr, b, bytes) != 0)
 		kill_guest(lg, "bad write address %#lx len %u", addr, bytes);
 }
+/* (end of memory access helper routines) :*/
 
 static void set_ts(void)
 {
diff -puN drivers/lguest/io.c~lguest-documentation-iv-launcher drivers/lguest/io.c
--- a/drivers/lguest/io.c~lguest-documentation-iv-launcher
+++ a/drivers/lguest/io.c
@@ -27,8 +27,36 @@
 #include <linux/uaccess.h>
 #include "lg.h"
 
+/*L:300
+ * I/O
+ *
+ * Getting data in and out of the Guest is quite an art.  There are numerous
+ * ways to do it, and they all suck differently.  We try to keep things fairly
+ * close to "real" hardware so our Guest's drivers don't look like an alien
+ * visitation in the middle of the Linux code, and yet make sure that Guests
+ * can talk directly to other Guests, not just the Launcher.
+ *
+ * To do this, the Guest gives us a key when it binds or sends DMA buffers.
+ * The key corresponds to a "physical" address inside the Guest (ie. a virtual
+ * address inside the Launcher process).  We don't, however, use this key
+ * directly.
+ *
+ * We want Guests which share memory to be able to DMA to each other: two
+ * Launchers can mmap memory the same file, then the Guests can communicate.
+ * Fortunately, the futex code provides us with a way to get a "union
+ * futex_key" corresponding to the memory lying at a virtual address: if the
+ * two processes share memory, the "union futex_key" for that memory will match
+ * even if the memory is mapped at different addresses in each.  So we always
+ * convert the keys to "union futex_key"s to compare them.
+ *
+ * Before we dive into this though, we need to look at another set of helper
+ * routines used throughout the Host kernel code to access Guest memory.
+ :*/
 static struct list_head dma_hash[61];
 
+/* An unfortunate side effect of the Linux double-linked list implementation is
+ * that there's no good way to statically initialize an array of linked
+ * lists. */
 void lguest_io_init(void)
 {
 	unsigned int i;
@@ -60,6 +88,19 @@ kill:
 	return 0;
 }
 
+/*L:330 This is our hash function, using the wonderful Jenkins hash.
+ *
+ * The futex key is a union with three parts: an unsigned long word, a pointer,
+ * and an int "offset".  We could use jhash_2words() which takes three u32s.
+ * (Ok, the hash functions are great: the naming sucks though).
+ *
+ * It's nice to be portable to 64-bit platforms, so we use the more generic
+ * jhash2(), which takes an array of u32, the number of u32s, and an initial
+ * u32 to roll in.  This is uglier, but breaks down to almost the same code on
+ * 32-bit platforms like this one.
+ *
+ * We want a position in the array, so we modulo ARRAY_SIZE(dma_hash) (ie. 61).
+ */
 static unsigned int hash(const union futex_key *key)
 {
 	return jhash2((u32*)&key->both.word,
@@ -68,6 +109,9 @@ static unsigned int hash(const union fut
 		% ARRAY_SIZE(dma_hash);
 }
 
+/* This is a convenience routine to compare two keys.  It's a much bemoaned C
+ * weakness that it doesn't allow '==' on structures or unions, so we have to
+ * open-code it like this. */
 static inline int key_eq(const union futex_key *a, const union futex_key *b)
 {
 	return (a->both.word == b->both.word
@@ -75,22 +119,36 @@ static inline int key_eq(const union fut
 		&& a->both.offset == b->both.offset);
 }
 
-/* Must hold read lock on dmainfo owner's current->mm->mmap_sem */
+/*L:360 OK, when we need to actually free up a Guest's DMA array we do several
+ * things, so we have a convenient function to do it.
+ *
+ * The caller must hold a read lock on dmainfo owner's current->mm->mmap_sem
+ * for the drop_futex_key_refs(). */
 static void unlink_dma(struct lguest_dma_info *dmainfo)
 {
+	/* You locked this too, right? */
 	BUG_ON(!mutex_is_locked(&lguest_lock));
+	/* This is how we know that the entry is free. */
 	dmainfo->interrupt = 0;
+	/* Remove it from the hash table. */
 	list_del(&dmainfo->list);
+	/* Drop the references we were holding (to the inode or mm). */
 	drop_futex_key_refs(&dmainfo->key);
 }
 
+/*L:350 This is the routine which we call when the Guest asks to unregister a
+ * DMA array attached to a given key.  Returns true if the array was found. */
 static int unbind_dma(struct lguest *lg,
 		      const union futex_key *key,
 		      unsigned long dmas)
 {
 	int i, ret = 0;
 
+	/* We don't bother with the hash table, just look through all this
+	 * Guest's DMA arrays. */
 	for (i = 0; i < LGUEST_MAX_DMA; i++) {
+		/* In theory it could have more than one array on the same key,
+		 * or one array on multiple keys, so we check both */
 		if (key_eq(key, &lg->dma[i].key) && dmas == lg->dma[i].dmas) {
 			unlink_dma(&lg->dma[i]);
 			ret = 1;
@@ -100,51 +158,91 @@ static int unbind_dma(struct lguest *lg,
 	return ret;
 }
 
+/*L:340 BIND_DMA: this is the hypercall which sets up an array of "struct
+ * lguest_dma" for receiving I/O.
+ *
+ * The Guest wants to bind an array of "struct lguest_dma"s to a particular key
+ * to receive input.  This only happens when the Guest is setting up a new
+ * device, so it doesn't have to be very fast.
+ *
+ * It returns 1 on a successful registration (it can fail if we hit the limit
+ * of registrations for this Guest).
+ */
 int bind_dma(struct lguest *lg,
 	     unsigned long ukey, unsigned long dmas, u16 numdmas, u8 interrupt)
 {
 	unsigned int i;
 	int ret = 0;
 	union futex_key key;
+	/* Futex code needs the mmap_sem. */
 	struct rw_semaphore *fshared = &current->mm->mmap_sem;
 
+	/* Invalid interrupt?  (We could kill the guest here). */
 	if (interrupt >= LGUEST_IRQS)
 		return 0;
 
+	/* We need to grab the Big Lguest Lock, because other Guests may be
+	 * trying to look through this Guest's DMAs to send something while
+	 * we're doing this. */
 	mutex_lock(&lguest_lock);
 	down_read(fshared);
 	if (get_futex_key((u32 __user *)ukey, fshared, &key) != 0) {
 		kill_guest(lg, "bad dma key %#lx", ukey);
 		goto unlock;
 	}
+
+	/* We want to keep this key valid once we drop mmap_sem, so we have to
+	 * hold a reference. */
 	get_futex_key_refs(&key);
 
+	/* If the Guest specified an interrupt of 0, that means they want to
+	 * unregister this array of "struct lguest_dma"s. */
 	if (interrupt == 0)
 		ret = unbind_dma(lg, &key, dmas);
 	else {
+		/* Look through this Guest's dma array for an unused entry. */
 		for (i = 0; i < LGUEST_MAX_DMA; i++) {
+			/* If the interrupt is non-zero, the entry is already
+			 * used. */
 			if (lg->dma[i].interrupt)
 				continue;
 
+			/* OK, a free one!  Fill on our details. */
 			lg->dma[i].dmas = dmas;
 			lg->dma[i].num_dmas = numdmas;
 			lg->dma[i].next_dma = 0;
 			lg->dma[i].key = key;
 			lg->dma[i].guestid = lg->guestid;
 			lg->dma[i].interrupt = interrupt;
+
+			/* Now we add it to the hash table: the position
+			 * depends on the futex key that we got. */
 			list_add(&lg->dma[i].list, &dma_hash[hash(&key)]);
+			/* Success! */
 			ret = 1;
 			goto unlock;
 		}
 	}
+	/* If we didn't find a slot to put the key in, drop the reference
+	 * again. */
 	drop_futex_key_refs(&key);
 unlock:
+	/* Unlock and out. */
  	up_read(fshared);
 	mutex_unlock(&lguest_lock);
 	return ret;
 }
 
-/* lgread from another guest */
+/*L:385 Note that our routines to access a different Guest's memory are called
+ * lgread_other() and lgwrite_other(): these names emphasize that they are only
+ * used when the Guest is *not* the current Guest.
+ *
+ * The interface for copying from another process's memory is called
+ * access_process_vm(), with a final argument of 0 for a read, and 1 for a
+ * write.
+ *
+ * We need lgread_other() to read the destination Guest's "struct lguest_dma"
+ * array. */
 static int lgread_other(struct lguest *lg,
 			void *buf, u32 addr, unsigned bytes)
 {
@@ -157,7 +255,8 @@ static int lgread_other(struct lguest *l
 	return 1;
 }
 
-/* lgwrite to another guest */
+/* "lgwrite()" to another Guest: used to update the destination "used_len" once
+ * we've transferred data into the buffer. */
 static int lgwrite_other(struct lguest *lg, u32 addr,
 			 const void *buf, unsigned bytes)
 {
@@ -170,6 +269,15 @@ static int lgwrite_other(struct lguest *
 	return 1;
 }
 
+/*L:400 This is the generic engine which copies from a source "struct
+ * lguest_dma" from this Guest into another Guest's "struct lguest_dma".  The
+ * destination Guest's pages have already been mapped, as contained in the
+ * pages array.
+ *
+ * If you're wondering if there's a nice "copy from one process to another"
+ * routine, so was I.  But Linux isn't really set up to copy between two
+ * unrelated processes, so we have to write it ourselves.
+ */
 static u32 copy_data(struct lguest *srclg,
 		     const struct lguest_dma *src,
 		     const struct lguest_dma *dst,
@@ -178,33 +286,59 @@ static u32 copy_data(struct lguest *srcl
 	unsigned int totlen, si, di, srcoff, dstoff;
 	void *maddr = NULL;
 
+	/* We return the total length transferred. */
 	totlen = 0;
+
+	/* We keep indexes into the source and destination "struct lguest_dma",
+	 * and an offset within each region. */
 	si = di = 0;
 	srcoff = dstoff = 0;
+
+	/* We loop until the source or destination is exhausted. */
 	while (si < LGUEST_MAX_DMA_SECTIONS && src->len[si]
 	       && di < LGUEST_MAX_DMA_SECTIONS && dst->len[di]) {
+		/* We can only transfer the rest of the src buffer, or as much
+		 * as will fit into the destination buffer. */
 		u32 len = min(src->len[si] - srcoff, dst->len[di] - dstoff);
 
+		/* For systems using "highmem" we need to use kmap() to access
+		 * the page we want.  We often use the same page over and over,
+		 * so rather than kmap() it on every loop, we set the maddr
+		 * pointer to NULL when we need to move to the next
+		 * destination page. */
 		if (!maddr)
 			maddr = kmap(pages[di]);
 
-		/* FIXME: This is not completely portable, since
-		   archs do different things for copy_to_user_page. */
+		/* Copy directly from (this Guest's) source address to the
+		 * destination Guest's kmap()ed buffer.  Note that maddr points
+		 * to the start of the page: we need to add the offset of the
+		 * destination address and offset within the buffer. */
+
+		/* FIXME: This is not completely portable.  I looked at
+		 * copy_to_user_page(), and some arch's seem to need special
+		 * flushes.  x86 is fine. */
 		if (copy_from_user(maddr + (dst->addr[di] + dstoff)%PAGE_SIZE,
 				   (void __user *)src->addr[si], len) != 0) {
+			/* If a copy failed, it's the source's fault. */
 			kill_guest(srclg, "bad address in sending DMA");
 			totlen = 0;
 			break;
 		}
 
+		/* Increment the total and src & dst offsets */
 		totlen += len;
 		srcoff += len;
 		dstoff += len;
+
+		/* Presumably we reached the end of the src or dest buffers: */
 		if (srcoff == src->len[si]) {
+			/* Move to the next buffer at offset 0 */
 			si++;
 			srcoff = 0;
 		}
 		if (dstoff == dst->len[di]) {
+			/* We need to unmap that destination page and reset
+			 * maddr ready for the next one. */
 			kunmap(pages[di]);
 			maddr = NULL;
 			di++;
@@ -212,13 +346,15 @@ static u32 copy_data(struct lguest *srcl
 		}
 	}
 
+	/* If we still had a page mapped at the end, unmap now. */
 	if (maddr)
 		kunmap(pages[di]);
 
 	return totlen;
 }
 
-/* Src is us, ie. current. */
+/*L:390 This is how we transfer a "struct lguest_dma" from the source Guest
+ * (the current Guest which called SEND_DMA) to another Guest. */
 static u32 do_dma(struct lguest *srclg, const struct lguest_dma *src,
 		  struct lguest *dstlg, const struct lguest_dma *dst)
 {
@@ -226,23 +362,31 @@ static u32 do_dma(struct lguest *srclg, 
 	u32 ret;
 	struct page *pages[LGUEST_MAX_DMA_SECTIONS];
 
+	/* We check that both source and destination "struct lguest_dma"s are
+	 * within the bounds of the source and destination Guests */
 	if (!check_dma_list(dstlg, dst) || !check_dma_list(srclg, src))
 		return 0;
 
-	/* First get the destination pages */
+	/* We need to map the pages which correspond to each parts of
+	 * destination buffer. */
 	for (i = 0; i < LGUEST_MAX_DMA_SECTIONS; i++) {
 		if (dst->len[i] == 0)
 			break;
+		/* get_user_pages() is a complicated function, especially since
+		 * we only want a single page.  But it works, and returns the
+		 * number of pages.  Note that we're holding the destination's
+		 * mmap_sem, as get_user_pages() requires. */
 		if (get_user_pages(dstlg->tsk, dstlg->mm,
 				   dst->addr[i], 1, 1, 1, pages+i, NULL)
 		    != 1) {
+			/* This means the destination gave us a bogus buffer */
 			kill_guest(dstlg, "Error mapping DMA pages");
 			ret = 0;
 			goto drop_pages;
 		}
 	}
 
-	/* Now copy until we run out of src or dst. */
+	/* Now copy the data until we run out of src or dst. */
 	ret = copy_data(srclg, src, dst, pages);
 
 drop_pages:
@@ -251,6 +395,11 @@ drop_pages:
 	return ret;
 }
 
+/*L:380 Transferring data from one Guest to another is not as simple as I'd
+ * like.  We've found the "struct lguest_dma_info" bound to the same address as
+ * the send, we need to copy into it.
+ *
+ * This function returns true if the destination array was empty. */
 static int dma_transfer(struct lguest *srclg,
 			unsigned long udma,
 			struct lguest_dma_info *dst)
@@ -259,15 +408,23 @@ static int dma_transfer(struct lguest *s
 	struct lguest *dstlg;
 	u32 i, dma = 0;
 
+	/* From the "struct lguest_dma_info" we found in the hash, grab the
+	 * Guest. */
 	dstlg = &lguests[dst->guestid];
-	/* Get our dma list. */
+	/* Read in the source "struct lguest_dma" handed to SEND_DMA. */
 	lgread(srclg, &src_dma, udma, sizeof(src_dma));
 
-	/* We can't deadlock against them dmaing to us, because this
-	 * is all under the lguest_lock. */
+	/* We need the destination's mmap_sem, and we already hold the source's
+	 * mmap_sem for the futex key lookup.  Normally this would suggest that
+	 * we could deadlock if the destination Guest was trying to send to
+	 * this source Guest at the same time, which is another reason that all
+	 * I/O is done under the big lguest_lock. */
 	down_read(&dstlg->mm->mmap_sem);
 
+	/* Look through the destination DMA array for an available buffer. */
 	for (i = 0; i < dst->num_dmas; i++) {
+		/* We keep a "next_dma" pointer which often helps us avoid
+		 * looking at lots of previously-filled entries. */
 		dma = (dst->next_dma + i) % dst->num_dmas;
 		if (!lgread_other(dstlg, &dst_dma,
 				  dst->dmas + dma * sizeof(struct lguest_dma),
@@ -277,30 +434,46 @@ static int dma_transfer(struct lguest *s
 		if (!dst_dma.used_len)
 			break;
 	}
+
+	/* If we found a buffer, we do the actual data copy. */
 	if (i != dst->num_dmas) {
 		unsigned long used_lenp;
 		unsigned int ret;
 
 		ret = do_dma(srclg, &src_dma, dstlg, &dst_dma);
-		/* Put used length in src. */
+		/* Put used length in the source "struct lguest_dma"'s used_len
+		 * field.  It's a little tricky to figure out where that is,
+		 * though. */
 		lgwrite_u32(srclg,
 			    udma+offsetof(struct lguest_dma, used_len), ret);
+		/* Tranferring 0 bytes is OK if the source buffer was empty. */
 		if (ret == 0 && src_dma.len[0] != 0)
 			goto fail;
 
-		/* Make sure destination sees contents before length. */
+		/* The destination Guest might be running on a different CPU:
+		 * we have to make sure that it will see the "used_len" field
+		 * change to non-zero *after* it sees the data we copied into
+		 * the buffer.  Hence a write memory barrier. */
 		wmb();
+		/* Figuring out where the destination's used_len field for this
+		 * "struct lguest_dma" in the array is also a little ugly. */
 		used_lenp = dst->dmas
 			+ dma * sizeof(struct lguest_dma)
 			+ offsetof(struct lguest_dma, used_len);
 		lgwrite_other(dstlg, used_lenp, &ret, sizeof(ret));
+		/* Move the cursor for next time. */
 		dst->next_dma++;
 	}
  	up_read(&dstlg->mm->mmap_sem);
 
-	/* Do this last so dst doesn't simply sleep on lock. */
+	/* We trigger the destination interrupt, even if the destination was
+	 * empty and we didn't transfer anything: this gives them a chance to
+	 * wake up and refill. */
 	set_bit(dst->interrupt, dstlg->irqs_pending);
+	/* Wake up the destination process. */
 	wake_up_process(dstlg->tsk);
+	/* If we passed the last "struct lguest_dma", the receive had no
+	 * buffers left. */
 	return i == dst->num_dmas;
 
 fail:
@@ -308,6 +481,8 @@ fail:
 	return 0;
 }
 
+/*L:370 This is the counter-side to the BIND_DMA hypercall; the SEND_DMA
+ * hypercall.  We find out who's listening, and send to them. */
 void send_dma(struct lguest *lg, unsigned long ukey, unsigned long udma)
 {
 	union futex_key key;
@@ -317,31 +492,43 @@ void send_dma(struct lguest *lg, unsigne
 again:
 	mutex_lock(&lguest_lock);
 	down_read(fshared);
+	/* Get the futex key for the key the Guest gave us */
 	if (get_futex_key((u32 __user *)ukey, fshared, &key) != 0) {
 		kill_guest(lg, "bad sending DMA key");
 		goto unlock;
 	}
-	/* Shared mapping?  Look for other guests... */
+	/* Since the key must be a multiple of 4, the futex key uses the lower
+	 * bit of the "offset" field (which would always be 0) to indicate a
+	 * mapping which is shared with other processes (ie. Guests). */
 	if (key.shared.offset & 1) {
 		struct lguest_dma_info *i;
+		/* Look through the hash for other Guests. */
 		list_for_each_entry(i, &dma_hash[hash(&key)], list) {
+			/* Don't send to ourselves. */
 			if (i->guestid == lg->guestid)
 				continue;
 			if (!key_eq(&key, &i->key))
 				continue;
 
+			/* If dma_transfer() tells us the destination has no
+			 * available buffers, we increment "empty". */
 			empty += dma_transfer(lg, udma, i);
 			break;
 		}
+		/* If the destination is empty, we release our locks and
+		 * give the destination Guest a brief chance to restock. */
 		if (empty == 1) {
 			/* Give any recipients one chance to restock. */
 			up_read(&current->mm->mmap_sem);
 			mutex_unlock(&lguest_lock);
+			/* Next time, we won't try again. */
 			empty++;
 			goto again;
 		}
 	} else {
-		/* Private mapping: tell our userspace. */
+		/* Private mapping: Guest is sending to its Launcher.  We set
+		 * the "dma_is_pending" flag so that the main loop will exit
+		 * and the Launcher's read() from /dev/lguest will return. */
 		lg->dma_is_pending = 1;
 		lg->pending_dma = udma;
 		lg->pending_key = ukey;
@@ -350,6 +537,7 @@ unlock:
 	up_read(fshared);
 	mutex_unlock(&lguest_lock);
 }
+/*:*/
 
 void release_all_dma(struct lguest *lg)
 {
@@ -365,7 +553,8 @@ void release_all_dma(struct lguest *lg)
 	up_read(&lg->mm->mmap_sem);
 }
 
-/* Userspace wants a dma buffer from this guest. */
+/*L:320 This routine looks for a DMA buffer registered by the Guest on the
+ * given key (using the BIND_DMA hypercall). */
 unsigned long get_dma_buffer(struct lguest *lg,
 			     unsigned long ukey, unsigned long *interrupt)
 {
@@ -374,15 +563,29 @@ unsigned long get_dma_buffer(struct lgue
 	struct lguest_dma_info *i;
 	struct rw_semaphore *fshared = &current->mm->mmap_sem;
 
+	/* Take the Big Lguest Lock to stop other Guests sending this Guest DMA
+	 * at the same time. */
 	mutex_lock(&lguest_lock);
+	/* To match between Guests sharing the same underlying memory we steal
+	 * code from the futex infrastructure.  This requires that we hold the
+	 * "mmap_sem" for our process (the Launcher), and pass it to the futex
+	 * code. */
 	down_read(fshared);
+
+	/* This can fail if it's not a valid address, or if the address is not
+	 * divisible by 4 (the futex code needs that, we don't really). */
 	if (get_futex_key((u32 __user *)ukey, fshared, &key) != 0) {
 		kill_guest(lg, "bad registered DMA buffer");
 		goto unlock;
 	}
+	/* Search the hash table for matching entries (the Launcher can only
+	 * send to its own Guest for the moment, so the entry must be for this
+	 * Guest) */
 	list_for_each_entry(i, &dma_hash[hash(&key)], list) {
 		if (key_eq(&key, &i->key) && i->guestid == lg->guestid) {
 			unsigned int j;
+			/* Look through the registered DMA array for an
+			 * available buffer. */
 			for (j = 0; j < i->num_dmas; j++) {
 				struct lguest_dma dma;
 
@@ -391,6 +594,8 @@ unsigned long get_dma_buffer(struct lgue
 				if (dma.used_len == 0)
 					break;
 			}
+			/* Store the interrupt the Guest wants when the buffer
+			 * is used. */
 			*interrupt = i->interrupt;
 			break;
 		}
@@ -400,4 +605,12 @@ unlock:
 	mutex_unlock(&lguest_lock);
 	return ret;
 }
+/*:*/
 
+/*L:410 This really has completed the Launcher.  Not only have we now finished
+ * the longest chapter in our journey, but this also means we are over halfway
+ * through!
+ *
+ * Enough prevaricating around the bush: it is time for us to dive into the
+ * core of the Host, in "make Host".
+ */
diff -puN drivers/lguest/lg.h~lguest-documentation-iv-launcher drivers/lguest/lg.h
--- a/drivers/lguest/lg.h~lguest-documentation-iv-launcher
+++ a/drivers/lguest/lg.h
@@ -244,6 +244,30 @@ unsigned long get_dma_buffer(struct lgue
 /* hypercalls.c: */
 void do_hypercalls(struct lguest *lg);
 
+/*L:035
+ * Let's step aside for the moment, to study one important routine that's used
+ * widely in the Host code.
+ *
+ * There are many cases where the Guest does something invalid, like pass crap
+ * to a hypercall.  Since only the Guest kernel can make hypercalls, it's quite
+ * acceptable to simply terminate the Guest and give the Launcher a nicely
+ * formatted reason.  It's also simpler for the Guest itself, which doesn't
+ * need to check most hypercalls for "success"; if you're still running, it
+ * succeeded.
+ *
+ * Once this is called, the Guest will never run again, so most Host code can
+ * call this then continue as if nothing had happened.  This means many
+ * functions don't have to explicitly return an error code, which keeps the
+ * code simple.
+ *
+ * It also means that this can be called more than once: only the first one is
+ * remembered.  The only trick is that we still need to kill the Guest even if
+ * we can't allocate memory to store the reason.  Linux has a neat way of
+ * packing error codes into invalid pointers, so we use that here.
+ *
+ * Like any macro which uses an "if", it is safely wrapped in a run-once "do {
+ * } while(0)".
+ */
 #define kill_guest(lg, fmt...)					\
 do {								\
 	if (!(lg)->dead) {					\
@@ -252,6 +276,7 @@ do {								\
 			(lg)->dead = ERR_PTR(-ENOMEM);		\
 	}							\
 } while(0)
+/* (End of aside) :*/
 
 static inline unsigned long guest_pa(struct lguest *lg, unsigned long vaddr)
 {
diff -puN drivers/lguest/lguest_user.c~lguest-documentation-iv-launcher drivers/lguest/lguest_user.c
--- a/drivers/lguest/lguest_user.c~lguest-documentation-iv-launcher
+++ a/drivers/lguest/lguest_user.c
@@ -9,33 +9,62 @@
 #include <linux/fs.h>
 #include "lg.h"
 
+/*L:030 setup_regs() doesn't really belong in this file, but it gives us an
+ * early glimpse deeper into the Host so it's worth having here.
+ *
+ * Most of the Guest's registers are left alone: we used get_zeroed_page() to
+ * allocate the structure, so they will be 0. */
 static void setup_regs(struct lguest_regs *regs, unsigned long start)
 {
-	/* Write out stack in format lguest expects, so we can switch to it. */
+	/* There are four "segment" registers which the Guest needs to boot:
+	 * The "code segment" register (cs) refers to the kernel code segment
+	 * __KERNEL_CS, and the "data", "extra" and "stack" segment registers
+	 * refer to the kernel data segment __KERNEL_DS.
+	 *
+	 * The privilege level is packed into the lower bits.  The Guest runs
+	 * at privilege level 1 (GUEST_PL).*/
 	regs->ds = regs->es = regs->ss = __KERNEL_DS|GUEST_PL;
 	regs->cs = __KERNEL_CS|GUEST_PL;
-	regs->eflags = 0x202; 	/* Interrupts enabled. */
+
+	/* The "eflags" register contains miscellaneous flags.  Bit 1 (0x002)
+	 * is supposed to always be "1".  Bit 9 (0x200) controls whether
+	 * interrupts are enabled.  We always leave interrupts enabled while
+	 * running the Guest. */
+	regs->eflags = 0x202;
+
+	/* The "Extended Instruction Pointer" register says where the Guest is
+	 * running. */
 	regs->eip = start;
-	/* esi points to our boot information (physical address 0) */
+
+	/* %esi points to our boot information, at physical address 0, so don't
+	 * touch it. */
 }
 
-/* + addr */
+/*L:310 To send DMA into the Guest, the Launcher needs to be able to ask for a
+ * DMA buffer.  This is done by writing LHREQ_GETDMA and the key to
+ * /dev/lguest. */
 static long user_get_dma(struct lguest *lg, const u32 __user *input)
 {
 	unsigned long key, udma, irq;
 
+	/* Fetch the key they wrote to us. */
 	if (get_user(key, input) != 0)
 		return -EFAULT;
+	/* Look for a free Guest DMA buffer bound to that key. */
 	udma = get_dma_buffer(lg, key, &irq);
 	if (!udma)
 		return -ENOENT;
 
-	/* We put irq number in udma->used_len. */
+	/* We need to tell the Launcher what interrupt the Guest expects after
+	 * the buffer is filled.  We stash it in udma->used_len. */
 	lgwrite_u32(lg, udma + offsetof(struct lguest_dma, used_len), irq);
+
+	/* The (guest-physical) address of the DMA buffer is returned from
+	 * the write(). */
 	return udma;
 }
 
-/* To force the Guest to stop running and return to the Launcher, the
+/*L:315 To force the Guest to stop running and return to the Launcher, the
  * Waker sets writes LHREQ_BREAK and the value "1" to /dev/lguest.  The
  * Launcher then writes LHREQ_BREAK and "0" to release the Waker. */
 static int break_guest_out(struct lguest *lg, const u32 __user *input)
@@ -59,7 +88,8 @@ static int break_guest_out(struct lguest
 	}
 }
 
-/* + irq */
+/*L:050 Sending an interrupt is done by writing LHREQ_IRQ and an interrupt
+ * number to /dev/lguest. */
 static int user_send_irq(struct lguest *lg, const u32 __user *input)
 {
 	u32 irq;
@@ -68,14 +98,19 @@ static int user_send_irq(struct lguest *
 		return -EFAULT;
 	if (irq >= LGUEST_IRQS)
 		return -EINVAL;
+	/* Next time the Guest runs, the core code will see if it can deliver
+	 * this interrupt. */
 	set_bit(irq, lg->irqs_pending);
 	return 0;
 }
 
+/*L:040 Once our Guest is initialized, the Launcher makes it run by reading
+ * from /dev/lguest. */
 static ssize_t read(struct file *file, char __user *user, size_t size,loff_t*o)
 {
 	struct lguest *lg = file->private_data;
 
+	/* You must write LHREQ_INITIALIZE first! */
 	if (!lg)
 		return -EINVAL;
 
@@ -83,27 +118,52 @@ static ssize_t read(struct file *file, c
 	if (current != lg->tsk)
 		return -EPERM;
 
+	/* If the guest is already dead, we indicate why */
 	if (lg->dead) {
 		size_t len;
 
+		/* lg->dead either contains an error code, or a string. */
 		if (IS_ERR(lg->dead))
 			return PTR_ERR(lg->dead);
 
+		/* We can only return as much as the buffer they read with. */
 		len = min(size, strlen(lg->dead)+1);
 		if (copy_to_user(user, lg->dead, len) != 0)
 			return -EFAULT;
 		return len;
 	}
 
+	/* If we returned from read() last time because the Guest sent DMA,
+	 * clear the flag. */
 	if (lg->dma_is_pending)
 		lg->dma_is_pending = 0;
 
+	/* Run the Guest until something interesting happens. */
 	return run_guest(lg, (unsigned long __user *)user);
 }
 
-/* Take: pfnlimit, pgdir, start, pageoffset. */
+/*L:020 The initialization write supplies 4 32-bit values (in addition to the
+ * 32-bit LHREQ_INITIALIZE value).  These are:
+ *
+ * pfnlimit: The highest (Guest-physical) page number the Guest should be
+ * allowed to access.  The Launcher has to live in Guest memory, so it sets
+ * this to ensure the Guest can't reach it.
+ *
+ * pgdir: The (Guest-physical) address of the top of the initial Guest
+ * pagetables (which are set up by the Launcher).
+ *
+ * start: The first instruction to execute ("eip" in x86-speak).
+ *
+ * page_offset: The PAGE_OFFSET constant in the Guest kernel.  We should
+ * probably wean the code off this, but it's a very useful constant!  Any
+ * address above this is within the Guest kernel, and any kernel address can
+ * quickly converted from physical to virtual by adding PAGE_OFFSET.  It's
+ * 0xC0000000 (3G) by default, but it's configurable at kernel build time.
+ */
 static int initialize(struct file *file, const u32 __user *input)
 {
+	/* "struct lguest" contains everything we (the Host) know about a
+	 * Guest. */
 	struct lguest *lg;
 	int err, i;
 	u32 args[4];
@@ -111,7 +171,7 @@ static int initialize(struct file *file,
 	/* We grab the Big Lguest lock, which protects the global array
 	 * "lguests" and multiple simultaneous initializations. */
 	mutex_lock(&lguest_lock);
-
+	/* You can't initialize twice!  Close the device and start again... */
 	if (file->private_data) {
 		err = -EBUSY;
 		goto unlock;
@@ -122,37 +182,70 @@ static int initialize(struct file *file,
 		goto unlock;
 	}
 
+	/* Find an unused guest. */
 	i = find_free_guest();
 	if (i < 0) {
 		err = -ENOSPC;
 		goto unlock;
 	}
+	/* OK, we have an index into the "lguest" array: "lg" is a convenient
+	 * pointer. */
 	lg = &lguests[i];
+
+	/* Populate the easy fields of our "struct lguest" */
 	lg->guestid = i;
 	lg->pfn_limit = args[0];
 	lg->page_offset = args[3];
+
+	/* We need a complete page for the Guest registers: they are accessible
+	 * to the Guest and we can only grant it access to whole pages. */
 	lg->regs_page = get_zeroed_page(GFP_KERNEL);
 	if (!lg->regs_page) {
 		err = -ENOMEM;
 		goto release_guest;
 	}
+	/* We actually put the registers at the bottom of the page. */
 	lg->regs = (void *)lg->regs_page + PAGE_SIZE - sizeof(*lg->regs);
 
+	/* Initialize the Guest's shadow page tables, using the toplevel
+	 * address the Launcher gave us.  This allocates memory, so can
+	 * fail. */
 	err = init_guest_pagetable(lg, args[1]);
 	if (err)
 		goto free_regs;
 
+	/* Now we initialize the Guest's registers, handing it the start
+	 * address. */
 	setup_regs(lg->regs, args[2]);
+
+	/* There are a couple of GDT entries the Guest expects when first
+	 * booting. */
 	setup_guest_gdt(lg);
+
+	/* The timer for lguest's clock needs initialization. */
 	init_clockdev(lg);
+
+	/* We keep a pointer to the Launcher task (ie. current task) for when
+	 * other Guests want to wake this one (inter-Guest I/O). */
 	lg->tsk = current;
+	/* We need to keep a pointer to the Launcher's memory map, because if
+	 * the Launcher dies we need to clean it up.  If we don't keep a
+	 * reference, it is destroyed before close() is called. */
 	lg->mm = get_task_mm(lg->tsk);
+
+	/* Initialize the queue for the waker to wait on */
 	init_waitqueue_head(&lg->break_wq);
+
+	/* We remember which CPU's pages this Guest used last, for optimization
+	 * when the same Guest runs on the same CPU twice. */
 	lg->last_pages = NULL;
+
+	/* We keep our "struct lguest" in the file's private_data. */
 	file->private_data = lg;
 
 	mutex_unlock(&lguest_lock);
 
+	/* And because this is a write() call, we return the length used. */
 	return sizeof(args);
 
 free_regs:
@@ -164,9 +257,15 @@ unlock:
 	return err;
 }
 
+/*L:010 The first operation the Launcher does must be a write.  All writes
+ * start with a 32 bit number: for the first write this must be
+ * LHREQ_INITIALIZE to set up the Guest.  After that the Launcher can use
+ * writes of other values to get DMA buffers and send interrupts. */
 static ssize_t write(struct file *file, const char __user *input,
 		     size_t size, loff_t *off)
 {
+	/* Once the guest is initialized, we hold the "struct lguest" in the
+	 * file private data. */
 	struct lguest *lg = file->private_data;
 	u32 req;
 
@@ -174,8 +273,11 @@ static ssize_t write(struct file *file, 
 		return -EFAULT;
 	input += sizeof(req);
 
+	/* If you haven't initialized, you must do that first. */
 	if (req != LHREQ_INITIALIZE && !lg)
 		return -EINVAL;
+
+	/* Once the Guest is dead, all you can do is read() why it died. */
 	if (lg && lg->dead)
 		return -ENOENT;
 
@@ -197,33 +299,72 @@ static ssize_t write(struct file *file, 
 	}
 }
 
+/*L:060 The final piece of interface code is the close() routine.  It reverses
+ * everything done in initialize().  This is usually called because the
+ * Launcher exited.
+ *
+ * Note that the close routine returns 0 or a negative error number: it can't
+ * really fail, but it can whine.  I blame Sun for this wart, and K&R C for
+ * letting them do it. :*/
 static int close(struct inode *inode, struct file *file)
 {
 	struct lguest *lg = file->private_data;
 
+	/* If we never successfully initialized, there's nothing to clean up */
 	if (!lg)
 		return 0;
 
+	/* We need the big lock, to protect from inter-guest I/O and other
+	 * Launchers initializing guests. */
 	mutex_lock(&lguest_lock);
 	/* Cancels the hrtimer set via LHCALL_SET_CLOCKEVENT. */
 	hrtimer_cancel(&lg->hrt);
+	/* Free any DMA buffers the Guest had bound. */
 	release_all_dma(lg);
+	/* Free up the shadow page tables for the Guest. */
 	free_guest_pagetable(lg);
+	/* Now all the memory cleanups are done, it's safe to release the
+	 * Launcher's memory management structure. */
 	mmput(lg->mm);
+	/* If lg->dead doesn't contain an error code it will be NULL or a
+	 * kmalloc()ed string, either of which is ok to hand to kfree(). */
 	if (!IS_ERR(lg->dead))
 		kfree(lg->dead);
+	/* We can free up the register page we allocated. */
 	free_page(lg->regs_page);
+	/* We clear the entire structure, which also marks it as free for the
+	 * next user. */
 	memset(lg, 0, sizeof(*lg));
+	/* Release lock and exit. */
 	mutex_unlock(&lguest_lock);
+
 	return 0;
 }
 
+/*L:000
+ * Welcome to our journey through the Launcher!
+ *
+ * The Launcher is the Host userspace program which sets up, runs and services
+ * the Guest.  In fact, many comments in the Drivers which refer to "the Host"
+ * doing things are inaccurate: the Launcher does all the device handling for
+ * the Guest.  The Guest can't tell what's done by the the Launcher and what by
+ * the Host.
+ *
+ * Just to confuse you: to the Host kernel, the Launcher *is* the Guest and we
+ * shall see more of that later.
+ *
+ * We begin our understanding with the Host kernel interface which the Launcher
+ * uses: reading and writing a character device called /dev/lguest.  All the
+ * work happens in the read(), write() and close() routines: */
 static struct file_operations lguest_fops = {
 	.owner	 = THIS_MODULE,
 	.release = close,
 	.write	 = write,
 	.read	 = read,
 };
+
+/* This is a textbook example of a "misc" character device.  Populate a "struct
+ * miscdevice" and register it with misc_register(). */
 static struct miscdevice lguest_dev = {
 	.minor	= MISC_DYNAMIC_MINOR,
 	.name	= "lguest",
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
git-newsetup-fixup.patch
readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
radixtree-introduce-radix_tree_next_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
mmaps2-vma-out-of-mem_size_stats.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
remove-unsafe-from-module-struct.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
