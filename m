From: akpm@linux-foundation.org
Subject: + random-clean-up-checkpatch-complaints.patch added to -mm tree
Date: Tue, 22 Jan 2008 01:33:12 -0800
Message-ID: <200801220932.m0M9WqIl014414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755516AbYAVJda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jan 2008 04:33:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mpm@selenic.com, tytso@mit.edu


The patch titled
     random: clean up checkpatch complaints
has been added to the -mm tree.  Its filename is
     random-clean-up-checkpatch-complaints.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: clean up checkpatch complaints
From: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   83 +++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 47 deletions(-)

diff -puN drivers/char/random.c~random-clean-up-checkpatch-complaints drivers/char/random.c
--- a/drivers/char/random.c~random-clean-up-checkpatch-complaints
+++ a/drivers/char/random.c
@@ -272,7 +272,7 @@ static int random_write_wakeup_thresh = 
 
 static int trickle_thresh __read_mostly = INPUT_POOL_WORDS * 28;
 
-static DEFINE_PER_CPU(int, trickle_count) = 0;
+static DEFINE_PER_CPU(int, trickle_count);
 
 /*
  * A pool of size .poolwords is stirred with a primitive polynomial
@@ -372,15 +372,16 @@ static DECLARE_WAIT_QUEUE_HEAD(random_re
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 
 #if 0
-static int debug = 0;
+static int debug;
 module_param(debug, bool, 0644);
-#define DEBUG_ENT(fmt, arg...) do { if (debug) \
-	printk(KERN_DEBUG "random %04d %04d %04d: " \
-	fmt,\
-	input_pool.entropy_count,\
-	blocking_pool.entropy_count,\
-	nonblocking_pool.entropy_count,\
-	## arg); } while (0)
+#define DEBUG_ENT(fmt, arg...) do { \
+	if (debug) \
+		printk(KERN_DEBUG "random %04d %04d %04d: " \
+		fmt,\
+		input_pool.entropy_count,\
+		blocking_pool.entropy_count,\
+		nonblocking_pool.entropy_count,\
+		## arg); } while (0)
 #else
 #define DEBUG_ENT(fmt, arg...) do {} while (0)
 #endif
@@ -551,7 +552,7 @@ static void credit_entropy_store(struct 
 /* There is one of these per entropy source */
 struct timer_rand_state {
 	cycles_t last_time;
-	long last_delta,last_delta2;
+	long last_delta, last_delta2;
 	unsigned dont_count_entropy:1;
 };
 
@@ -624,7 +625,7 @@ static void add_timer_randomness(struct 
 				     min_t(int, fls(delta>>1), 11));
 	}
 
-	if(input_pool.entropy_count >= random_read_wakeup_thresh)
+	if (input_pool.entropy_count >= random_read_wakeup_thresh)
 		wake_up_interruptible(&random_read_wait);
 
 out:
@@ -667,7 +668,6 @@ void add_disk_randomness(struct gendisk 
 	add_timer_randomness(disk->random,
 			     0x100 + MKDEV(disk->major, disk->first_minor));
 }
-
 EXPORT_SYMBOL(add_disk_randomness);
 #endif
 
@@ -679,7 +679,7 @@ EXPORT_SYMBOL(add_disk_randomness);
  *
  *********************************************************************/
 
-static ssize_t extract_entropy(struct entropy_store *r, void * buf,
+static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 			       size_t nbytes, int min, int rsvd);
 
 /*
@@ -706,8 +706,8 @@ static void xfer_secondary_pool(struct e
 			  "(%d of %d requested)\n",
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
-		bytes=extract_entropy(r->pull, tmp, bytes,
-				      random_read_wakeup_thresh / 8, rsvd);
+		bytes = extract_entropy(r->pull, tmp, bytes,
+					random_read_wakeup_thresh / 8, rsvd);
 		add_entropy_words(r, tmp, (bytes + 3) / 4);
 		credit_entropy_store(r, bytes*8);
 	}
@@ -746,7 +746,7 @@ static size_t account(struct entropy_sto
 		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
 			nbytes = r->entropy_count/8 - reserved;
 
-		if(r->entropy_count / 8 >= nbytes + reserved)
+		if (r->entropy_count / 8 >= nbytes + reserved)
 			r->entropy_count -= nbytes*8;
 		else
 			r->entropy_count = reserved;
@@ -804,7 +804,7 @@ static void extract_buf(struct entropy_s
 	memset(buf, 0, sizeof(buf));
 }
 
-static ssize_t extract_entropy(struct entropy_store *r, void * buf,
+static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 			       size_t nbytes, int min, int reserved)
 {
 	ssize_t ret = 0, i;
@@ -874,7 +874,6 @@ void get_random_bytes(void *buf, int nby
 {
 	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
 }
-
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
@@ -942,7 +941,7 @@ void rand_initialize_disk(struct gendisk
 #endif
 
 static ssize_t
-random_read(struct file * file, char __user * buf, size_t nbytes, loff_t *ppos)
+random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	ssize_t n, retval = 0, count = 0;
 
@@ -1004,8 +1003,7 @@ random_read(struct file * file, char __u
 }
 
 static ssize_t
-urandom_read(struct file * file, char __user * buf,
-		      size_t nbytes, loff_t *ppos)
+urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	return extract_entropy_user(&nonblocking_pool, buf, nbytes);
 }
@@ -1047,9 +1045,8 @@ write_pool(struct entropy_store *r, cons
 	return 0;
 }
 
-static ssize_t
-random_write(struct file * file, const char __user * buffer,
-	     size_t count, loff_t *ppos)
+static ssize_t random_write(struct file *file, const char __user *buffer,
+			    size_t count, loff_t *ppos)
 {
 	size_t ret;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -1066,9 +1063,8 @@ random_write(struct file * file, const c
 	return (ssize_t)count;
 }
 
-static int
-random_ioctl(struct inode * inode, struct file * file,
-	     unsigned int cmd, unsigned long arg)
+static int random_ioctl(struct inode *inode, struct file *file,
+			unsigned int cmd, unsigned long arg)
 {
 	int size, ent_count;
 	int __user *p = (int __user *)arg;
@@ -1159,7 +1155,6 @@ void generate_random_uuid(unsigned char 
 	/* Set the UUID variant to DCE */
 	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
 }
-
 EXPORT_SYMBOL(generate_random_uuid);
 
 /********************************************************************
@@ -1334,14 +1329,14 @@ ctl_table random_table[] = {
  * Rotation is separate from addition to prevent recomputation
  */
 #define ROUND(f, a, b, c, d, x, s)	\
-	(a += f(b, c, d) + x, a = (a << s) | (a >> (32 - s)))
+	(a += f(b, c, d) + in[x], a = (a << s) | (a >> (32 - s)))
 #define K1 0
 #define K2 013240474631UL
 #define K3 015666365641UL
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 
-static __u32 twothirdsMD4Transform (__u32 const buf[4], __u32 const in[12])
+static __u32 twothirdsMD4Transform(__u32 const buf[4], __u32 const in[12])
 {
 	__u32 a = buf[0], b = buf[1], c = buf[2], d = buf[3];
 
@@ -1489,8 +1484,8 @@ __u32 secure_tcpv6_sequence_number(__be3
 	 */
 
 	memcpy(hash, saddr, 16);
-	hash[4]=((__force u16)sport << 16) + (__force u16)dport;
-	memcpy(&hash[5],keyptr->secret,sizeof(__u32) * 7);
+	hash[4] = ((__force u16)sport << 16) + (__force u16)dport;
+	memcpy(&hash[5], keyptr->secret, sizeof(__u32) * 7);
 
 	seq = twothirdsMD4Transform((const __u32 *)daddr, hash) & HASH_MASK;
 	seq += keyptr->count;
@@ -1540,10 +1535,10 @@ __u32 secure_tcp_sequence_number(__be32 
 	 *  Note that the words are placed into the starting vector, which is
 	 *  then mixed with a partial MD4 over random data.
 	 */
-	hash[0]=(__force u32)saddr;
-	hash[1]=(__force u32)daddr;
-	hash[2]=((__force u16)sport << 16) + (__force u16)dport;
-	hash[3]=keyptr->secret[11];
+	hash[0] = (__force u32)saddr;
+	hash[1] = (__force u32)daddr;
+	hash[2] = ((__force u16)sport << 16) + (__force u16)dport;
+	hash[3] = keyptr->secret[11];
 
 	seq = half_md4_transform(hash, keyptr->secret) & HASH_MASK;
 	seq += keyptr->count;
@@ -1558,10 +1553,7 @@ __u32 secure_tcp_sequence_number(__be32 
 	 *	Choosing a clock of 64 ns period is OK. (period of 274 s)
 	 */
 	seq += ktime_to_ns(ktime_get_real()) >> 6;
-#if 0
-	printk("init_seq(%lx, %lx, %d, %d) = %d\n",
-	       saddr, daddr, sport, dport, seq);
-#endif
+
 	return seq;
 }
 
@@ -1584,14 +1576,15 @@ u32 secure_ipv4_port_ephemeral(__be32 sa
 }
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr, __be16 dport)
+u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+			       __be16 dport)
 {
 	struct keydata *keyptr = get_keyptr();
 	u32 hash[12];
 
 	memcpy(hash, saddr, 16);
 	hash[4] = (__force u32)dport;
-	memcpy(&hash[5],keyptr->secret,sizeof(__u32) * 7);
+	memcpy(&hash[5], keyptr->secret, sizeof(__u32) * 7);
 
 	return twothirdsMD4Transform((const __u32 *)daddr, hash);
 }
@@ -1619,13 +1612,9 @@ u64 secure_dccp_sequence_number(__be32 s
 
 	seq += ktime_to_ns(ktime_get_real());
 	seq &= (1ull << 48) - 1;
-#if 0
-	printk("dccp init_seq(%lx, %lx, %d, %d) = %d\n",
-	       saddr, daddr, sport, dport, seq);
-#endif
+
 	return seq;
 }
-
 EXPORT_SYMBOL(secure_dccp_sequence_number);
 #endif
 
_

Patches currently in -mm which might be from mpm@selenic.com are

git-x86.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
maps4-rework-task_size-macros.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-move-is_swap_pte.patch
maps4-introduce-a-generic-page-walker.patch
maps4-use-pagewalker-in-clear_refs-and-smaps.patch
maps4-simplify-interdependence-of-maps-and-smaps.patch
maps4-move-clear_refs-code-to-task_mmuc.patch
maps4-regroup-task_mmu-by-interface.patch
maps4-add-proc-pid-pagemap-interface.patch
maps4-add-proc-pid-pagemap-interface-fix.patch
maps4-add-proc-kpagecount-interface.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
remove-unused-code-from-mm-tiny-shmemc.patch
drivers-char-randomcwrite_pool-cond_resched-needed.patch
random-clean-up-checkpatch-complaints.patch
random-consolidate-wakeup-logic.patch
random-use-unlocked_ioctl.patch
random-reuse-rand_initialize.patch
random-improve-variable-naming-clear-extract-buffer.patch
random-make-backtracking-attacks-harder.patch
random-remove-cacheline-alignment-for-locks.patch
random-eliminate-redundant-new_rotate-variable.patch
random-remove-some-prefetch-logic.patch
random-simplify-add_ptr-logic.patch
random-make-mixing-interface-byte-oriented.patch
random-simplify-and-rename-credit_entropy_store.patch
