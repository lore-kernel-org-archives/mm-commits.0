From: akpm@linux-foundation.org
Subject: + lib-vsprintf-implement-bitmap-printing-through-%pb.patch added
 to -mm tree
Date: Mon, 26 Jan 2015 15:06:43 -0800
Message-ID: <54c6c883.OgJ/XnMX0IycOkda%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbAZXGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jan 2015 18:06:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, James.Bottomley@HansenPartnership.com, benh@kernel.crashing.org, chris@zankel.net, cl@linux.com, cmetcalf@tilera.com, davem@davemloft.net, dmitry.torokhov@gmail.com, fenghua.yu@intel.com, gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, linux@arm.linux.org.uk, linville@tuxdriver.com, lizefan@huawei.com, mingo@redhat.com, paulmck@linux.vnet.ibm.com, penberg@kernel.org, peterz@infradead.org, rostedt@goodmis.org, rusty@rustcorp.com.au, steffen.klassert@secunet.com, tglx@linutronix.de, tony.luck@intel.com, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: implement bitmap printing through '%*pb[l]'
has been added to the -mm tree.  Its filename is
     lib-vsprintf-implement-bitmap-printing-through-%pb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-implement-bitmap-printing-through-%25pb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintf-implement-bitmap-printing-through-%25pb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: lib/vsprintf: implement bitmap printing through '%*pb[l]'

bitmap and its derivatives such as cpumask and nodemask currently only
provide formatting functions which put the output string into the
provided buffer; however, how long this buffer should be isn't defined
anywhere and given that some of these bitmaps can be too large to be
formatted into an on-stack buffer it users sometimes are unnecessarily
forced to come up with creative solutions and compromises for the
buffer just to printk these bitmaps.

There have been a couple different attempts at making this easier.

1. Way back, PeterZ tried printk '%pb' extension with the precision
   for bit width - '%.*pb'.  This was intuitive and made sense but
   unfortunately triggered a compile warning about using precision
   for a pointer.

   http://lkml.kernel.org/g/1336577562.2527.58.camel@twins

2. I implemented bitmap_pr_cont[_list]() and its wrappers for cpumask
   and nodemask.  This works but PeterZ pointed out that pr_cont's
   tendency to produce broken lines when multiple CPUs are printing is
   bothering considering the usages.

   http://lkml.kernel.org/g/1418226774-30215-3-git-send-email-tj@kernel.org

So, this patch is another attempt at teaching printk and friends how
to print bitmaps.  It's almost identical to what PeterZ tried with
precision but it uses the field width for the number of bits instead
of precision.  The format used is '%*pb[l]', with the optional
trailing 'l' specifying list format instead of hex masks.

This is a valid format string and doesn't trigger compiler warnings;
however, it does make it impossible to specify output field width when
printing bitmaps.  I think this is an acceptable trade-off given how
much easier it makes printing bitmaps and that we don't have any
in-kernel user which is using the field width specification.  If any
future user wants to use field width with a bitmap, it'd have to
format the bitmap into a string buffer and then print that buffer with
width spec, which isn't different from how it should be done now.

This patch implements bitmap[_list]_string() which are called from the
vsprintf pointer() formatting function.  The implementation is mostly
identical to bitmap_scn[list]printf() except that the output is
performed in the vsprintf way.  These functions handle formatting into
too small buffers and sprintf() family of functions report the correct
overrun output length.

bitmap_scn[list]printf() are now thin wrappers around scnprintf().

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c   |   61 +-----------------------------
 lib/vsprintf.c |   94 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 59 deletions(-)

diff -puN lib/bitmap.c~lib-vsprintf-implement-bitmap-printing-through-%pb lib/bitmap.c
--- a/lib/bitmap.c~lib-vsprintf-implement-bitmap-printing-through-%pb
+++ a/lib/bitmap.c
@@ -383,28 +383,7 @@ EXPORT_SYMBOL(bitmap_find_next_zero_area
 int bitmap_scnprintf(char *buf, unsigned int buflen,
 	const unsigned long *maskp, int nmaskbits)
 {
-	int i, word, bit, len = 0;
-	unsigned long val;
-	const char *sep = "";
-	int chunksz;
-	u32 chunkmask;
-
-	chunksz = nmaskbits & (CHUNKSZ - 1);
-	if (chunksz == 0)
-		chunksz = CHUNKSZ;
-
-	i = ALIGN(nmaskbits, CHUNKSZ) - CHUNKSZ;
-	for (; i >= 0; i -= CHUNKSZ) {
-		chunkmask = ((1ULL << chunksz) - 1);
-		word = i / BITS_PER_LONG;
-		bit = i % BITS_PER_LONG;
-		val = (maskp[word] >> bit) & chunkmask;
-		len += scnprintf(buf+len, buflen-len, "%s%0*lx", sep,
-			(chunksz+3)/4, val);
-		chunksz = CHUNKSZ;
-		sep = ",";
-	}
-	return len;
+	return scnprintf(buf, buflen, "%*pb", nmaskbits, maskp);
 }
 EXPORT_SYMBOL(bitmap_scnprintf);
 
@@ -521,25 +500,6 @@ int bitmap_parse_user(const char __user
 }
 EXPORT_SYMBOL(bitmap_parse_user);
 
-/*
- * bscnl_emit(buf, buflen, rbot, rtop, bp)
- *
- * Helper routine for bitmap_scnlistprintf().  Write decimal number
- * or range to buf, suppressing output past buf+buflen, with optional
- * comma-prefix.  Return len of what was written to *buf, excluding the
- * trailing \0.
- */
-static inline int bscnl_emit(char *buf, int buflen, int rbot, int rtop, int len)
-{
-	if (len > 0)
-		len += scnprintf(buf + len, buflen - len, ",");
-	if (rbot == rtop)
-		len += scnprintf(buf + len, buflen - len, "%d", rbot);
-	else
-		len += scnprintf(buf + len, buflen - len, "%d-%d", rbot, rtop);
-	return len;
-}
-
 /**
  * bitmap_scnlistprintf - convert bitmap to list format ASCII string
  * @buf: byte buffer into which string is placed
@@ -559,24 +519,7 @@ static inline int bscnl_emit(char *buf,
 int bitmap_scnlistprintf(char *buf, unsigned int buflen,
 	const unsigned long *maskp, int nmaskbits)
 {
-	int len = 0;
-	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
-	int cur, rbot, rtop;
-
-	if (buflen == 0)
-		return 0;
-	buf[0] = 0;
-
-	rbot = cur = find_first_bit(maskp, nmaskbits);
-	while (cur < nmaskbits) {
-		rtop = cur;
-		cur = find_next_bit(maskp, nmaskbits, cur+1);
-		if (cur >= nmaskbits || cur > rtop + 1) {
-			len = bscnl_emit(buf, buflen, rbot, rtop, len);
-			rbot = cur;
-		}
-	}
-	return len;
+	return scnprintf(buf, buflen, "%*pbl", nmaskbits, maskp);
 }
 EXPORT_SYMBOL(bitmap_scnlistprintf);
 
diff -puN lib/vsprintf.c~lib-vsprintf-implement-bitmap-printing-through-%pb lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintf-implement-bitmap-printing-through-%pb
+++ a/lib/vsprintf.c
@@ -794,6 +794,87 @@ char *hex_string(char *buf, char *end, u
 }
 
 static noinline_for_stack
+char *bitmap_string(char *buf, char *end, unsigned long *bitmap,
+		    struct printf_spec spec, const char *fmt)
+{
+	const int CHUNKSZ = 32;
+	int nr_bits = max_t(int, spec.field_width, 0);
+	int i, chunksz;
+	bool first = true;
+
+	/* reused to print numbers */
+	spec = (struct printf_spec){ .flags = SMALL | ZEROPAD, .base = 16 };
+
+	chunksz = nr_bits & (CHUNKSZ - 1);
+	if (chunksz == 0)
+		chunksz = CHUNKSZ;
+
+	i = ALIGN(nr_bits, CHUNKSZ) - CHUNKSZ;
+	for (; i >= 0; i -= CHUNKSZ) {
+		u32 chunkmask, val;
+		int word, bit;
+
+		chunkmask = ((1ULL << chunksz) - 1);
+		word = i / BITS_PER_LONG;
+		bit = i % BITS_PER_LONG;
+		val = (bitmap[word] >> bit) & chunkmask;
+
+		if (!first) {
+			if (buf < end)
+				*buf = ',';
+			buf++;
+		}
+		first = false;
+
+		spec.field_width = DIV_ROUND_UP(chunksz, 4);
+		buf = number(buf, end, val, spec);
+
+		chunksz = CHUNKSZ;
+	}
+	return buf;
+}
+
+static noinline_for_stack
+char *bitmap_list_string(char *buf, char *end, unsigned long *bitmap,
+			 struct printf_spec spec, const char *fmt)
+{
+	int nr_bits = max_t(int, spec.field_width, 0);
+	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
+	int cur, rbot, rtop;
+	bool first = true;
+
+	/* reused to print numbers */
+	spec = (struct printf_spec){ .base = 10 };
+
+	rbot = cur = find_first_bit(bitmap, nr_bits);
+	while (cur < nr_bits) {
+		rtop = cur;
+		cur = find_next_bit(bitmap, nr_bits, cur + 1);
+		if (cur < nr_bits && cur <= rtop + 1)
+			continue;
+
+		if (!first) {
+			if (buf < end)
+				*buf = ',';
+			buf++;
+		}
+		first = false;
+
+		buf = number(buf, end, rbot, spec);
+		if (rbot < rtop) {
+			if (buf < end)
+				*buf = '-';
+			buf++;
+
+			buf = number(buf, end, rtop, spec);
+		}
+
+		rbot = cur;
+	}
+	return buf;
+}
+
+static noinline_for_stack
 char *mac_address_string(char *buf, char *end, u8 *addr,
 			 struct printf_spec spec, const char *fmt)
 {
@@ -1273,6 +1354,10 @@ int kptr_restrict __read_mostly;
  * - 'B' For backtraced symbolic direct pointers with offset
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
+ * - 'b[l]' For a bitmap, the number of bits is determined by the field
+ *       width which must be explicitly specified either as part of the
+ *       format string '%32b[l]' or through '%*b[l]', [l] selects
+ *       range-list format instead of hex format
  * - 'M' For a 6-byte MAC address, it prints the address in the
  *       usual colon-separated hex notation
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
@@ -1370,6 +1455,13 @@ char *pointer(const char *fmt, char *buf
 		return resource_string(buf, end, ptr, spec, fmt);
 	case 'h':
 		return hex_string(buf, end, ptr, spec, fmt);
+	case 'b':
+		switch (fmt[1]) {
+		case 'l':
+			return bitmap_list_string(buf, end, ptr, spec, fmt);
+		default:
+			return bitmap_string(buf, end, ptr, spec, fmt);
+		}
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */
 					/* [mM]F (FDDI) */
@@ -1707,6 +1799,8 @@ qualifier:
  * %pB output the name of a backtrace symbol with its offset
  * %pR output the address range in a struct resource with decoded flags
  * %pr output the address range in a struct resource with raw flags
+ * %pb output the bitmap with field width as the number of bits
+ * %pbl output the bitmap as range list with field width as the number of bits
  * %pM output a 6-byte MAC address with colons
  * %pMR output a 6-byte MAC address with colons in reversed order
  * %pMF output a 6-byte MAC address with dashes
_

Patches currently in -mm which might be from tj@kernel.org are

block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
vmscan-force-scan-offline-memory-cgroups-fix.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
mm-util-add-kstrdup_const.patch
kernfs-convert-node-name-allocation-to-kstrdup_const.patch
kernfs-remove-kernfs_static_name.patch
clk-convert-clock-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const-fix.patch
fs-namespace-convert-devname-allocation-to-kstrdup_const.patch
cpumask-always-use-nr_cpu_ids-in-formatting-and-parsing-functions.patch
lib-vsprintf-implement-bitmap-printing-through-%pb.patch
cpumask-nodemask-implement-cpumask-nodemask_pr_args.patch
bitmap-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
mips-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
powerpc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
tile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
x86-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
ia64-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
xtensa-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
arm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
cpuset-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
rcu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
sched-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
time-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
percpu-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
workqueue-use-%pb-to-format-bitmaps-including-cpumasks-and-nodemasks.patch
tracing-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
net-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
wireless-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
input-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
scsi-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
usb-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
drivers-base-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
slub-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
mm-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
padata-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
proc-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
irq-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
profile-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch
bitmap-cpumask-nodemask-remove-dedicated-formatting-functions.patch
linux-next.patch

