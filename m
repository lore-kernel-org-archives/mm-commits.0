From: akpm@linux-foundation.org
Subject: - random-clean-up-checkpatch-complaints.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:05 -0700
Message-ID: <200804300548.m3U5m5dh029849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758682AbYD3FtI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mpm@selenic.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     random: clean up checkpatch complaints
has been removed from the -mm tree.  Its filename was
     random-clean-up-checkpatch-complaints.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: random: clean up checkpatch complaints
From: Matt Mackall <mpm@selenic.com>

Signed-off-by: Matt Mackall <mpm@selenic.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/random.c |   80 +++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 45 deletions(-)

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
@@ -677,7 +678,7 @@ void add_disk_randomness(struct gendisk 
  *
  *********************************************************************/
 
-static ssize_t extract_entropy(struct entropy_store *r, void * buf,
+static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 			       size_t nbytes, int min, int rsvd);
 
 /*
@@ -704,8 +705,8 @@ static void xfer_secondary_pool(struct e
 			  "(%d of %d requested)\n",
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
-		bytes=extract_entropy(r->pull, tmp, bytes,
-				      random_read_wakeup_thresh / 8, rsvd);
+		bytes = extract_entropy(r->pull, tmp, bytes,
+					random_read_wakeup_thresh / 8, rsvd);
 		add_entropy_words(r, tmp, (bytes + 3) / 4);
 		credit_entropy_store(r, bytes*8);
 	}
@@ -744,7 +745,7 @@ static size_t account(struct entropy_sto
 		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
 			nbytes = r->entropy_count/8 - reserved;
 
-		if(r->entropy_count / 8 >= nbytes + reserved)
+		if (r->entropy_count / 8 >= nbytes + reserved)
 			r->entropy_count -= nbytes*8;
 		else
 			r->entropy_count = reserved;
@@ -802,7 +803,7 @@ static void extract_buf(struct entropy_s
 	memset(buf, 0, sizeof(buf));
 }
 
-static ssize_t extract_entropy(struct entropy_store *r, void * buf,
+static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 			       size_t nbytes, int min, int reserved)
 {
 	ssize_t ret = 0, i;
@@ -872,7 +873,6 @@ void get_random_bytes(void *buf, int nby
 {
 	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
 }
-
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
@@ -940,7 +940,7 @@ void rand_initialize_disk(struct gendisk
 #endif
 
 static ssize_t
-random_read(struct file * file, char __user * buf, size_t nbytes, loff_t *ppos)
+random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	ssize_t n, retval = 0, count = 0;
 
@@ -1002,8 +1002,7 @@ random_read(struct file * file, char __u
 }
 
 static ssize_t
-urandom_read(struct file * file, char __user * buf,
-		      size_t nbytes, loff_t *ppos)
+urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	return extract_entropy_user(&nonblocking_pool, buf, nbytes);
 }
@@ -1045,9 +1044,8 @@ write_pool(struct entropy_store *r, cons
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
@@ -1064,9 +1062,8 @@ random_write(struct file * file, const c
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
@@ -1157,7 +1154,6 @@ void generate_random_uuid(unsigned char 
 	/* Set the UUID variant to DCE */
 	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
 }
-
 EXPORT_SYMBOL(generate_random_uuid);
 
 /********************************************************************
@@ -1339,7 +1335,7 @@ ctl_table random_table[] = {
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 
-static __u32 twothirdsMD4Transform (__u32 const buf[4], __u32 const in[12])
+static __u32 twothirdsMD4Transform(__u32 const buf[4], __u32 const in[12])
 {
 	__u32 a = buf[0], b = buf[1], c = buf[2], d = buf[3];
 
@@ -1487,8 +1483,8 @@ __u32 secure_tcpv6_sequence_number(__be3
 	 */
 
 	memcpy(hash, saddr, 16);
-	hash[4]=((__force u16)sport << 16) + (__force u16)dport;
-	memcpy(&hash[5],keyptr->secret,sizeof(__u32) * 7);
+	hash[4] = ((__force u16)sport << 16) + (__force u16)dport;
+	memcpy(&hash[5], keyptr->secret, sizeof(__u32) * 7);
 
 	seq = twothirdsMD4Transform((const __u32 *)daddr, hash) & HASH_MASK;
 	seq += keyptr->count;
@@ -1538,10 +1534,10 @@ __u32 secure_tcp_sequence_number(__be32 
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
@@ -1556,10 +1552,7 @@ __u32 secure_tcp_sequence_number(__be32 
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
 
@@ -1582,14 +1575,15 @@ u32 secure_ipv4_port_ephemeral(__be32 sa
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
@@ -1617,13 +1611,9 @@ u64 secure_dccp_sequence_number(__be32 s
 
 	seq += ktime_to_ns(ktime_get_real());
 	seq &= (1ull << 48) - 1;
-#if 0
-	printk("dccp init_seq(%lx, %lx, %d, %d) = %d\n",
-	       saddr, daddr, sport, dport, seq);
-#endif
+
 	return seq;
 }
