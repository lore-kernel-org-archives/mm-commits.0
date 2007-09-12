From: akpm@linux-foundation.org
Subject: - ktime_sub_ns-analog-of-ktime_add_ns.patch removed from -mm tree
Date: Tue, 11 Sep 2007 20:49:29 -0700
Message-ID: <200709120349.l8C3nTlR014833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39660 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975AbXILDtb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 23:49:31 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8C3nUxg001604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2007 20:49:31 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     ktime_sub_ns: analog of ktime_add_ns
has been removed from the -mm tree.  Its filename was
     ktime_sub_ns-analog-of-ktime_add_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ktime_sub_ns: analog of ktime_add_ns
From: Stephen Hemminger <shemminger@linux-foundation.org>

Add macro/function to subtract constant nanoseconds.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ktime.h |   16 ++++++++++++++++
 kernel/hrtimer.c      |   24 ++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff -puN include/linux/ktime.h~ktime_sub_ns-analog-of-ktime_add_ns include/linux/ktime.h
--- a/include/linux/ktime.h~ktime_sub_ns-analog-of-ktime_add_ns
+++ a/include/linux/ktime.h
@@ -102,6 +102,13 @@ static inline ktime_t ktime_set(const lo
 #define ktime_add_ns(kt, nsval) \
 		({ (ktime_t){ .tv64 = (kt).tv64 + (nsval) }; })
 
+/*
+ * Subtract a ktime_t variable and a scalar nanosecond value.
+ * res = kt - nsval:
+ */
+#define ktime_sub_ns(kt, nsval) \
+		({ (ktime_t){ .tv64 = (kt).tv64 - (nsval) }; })
+
 /* convert a timespec to ktime_t format: */
 static inline ktime_t timespec_to_ktime(struct timespec ts)
 {
@@ -200,6 +207,15 @@ static inline ktime_t ktime_add(const kt
 extern ktime_t ktime_add_ns(const ktime_t kt, u64 nsec);
 
 /**
+ * ktime_sub_ns - Subtract a scalar nanoseconds value to a ktime_t variable
+ * @kt:	        minuend
+ * @nsec:	subtrahend in nanoseconds
+ *
+ * Returns the difference of @kt and @nsec in ktime_t format
+ */
+extern ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec);
+
+/**
  * timespec_to_ktime - convert a timespec to ktime_t format
  * @ts:		the timespec variable to convert
  *
diff -puN kernel/hrtimer.c~ktime_sub_ns-analog-of-ktime_add_ns kernel/hrtimer.c
--- a/kernel/hrtimer.c~ktime_sub_ns-analog-of-ktime_add_ns
+++ a/kernel/hrtimer.c
@@ -277,6 +277,30 @@ ktime_t ktime_add_ns(const ktime_t kt, u
 }
 
 EXPORT_SYMBOL_GPL(ktime_add_ns);
+
+/**
+ * ktime_sub_ns - Subract a scalar nanoseconds value to a ktime_t variable
+ * @kt:		minuend
+ * @nsec:	subtrahend in nanoseconds
+ *
+ * Returns the difference of kt and nsec in ktime_t format
+ */
+ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
+{
+	ktime_t tmp;
+
+	if (likely(nsec < NSEC_PER_SEC)) {
+		tmp.tv64 = nsec;
+	} else {
+		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
+
+		tmp = ktime_set((long)nsec, rem);
+	}
+
+	return ktime_sub(kt, tmp);
+}
+
+EXPORT_SYMBOL_GPL(ktime_add_ns);
 # endif /* !CONFIG_KTIME_SCALAR */
 
 /*
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

pci-x-pci-express-read-control-interfaces-mthca.patch
git-netdev-all.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
ktime_sub_ns-analog-of-ktime_add_ns.patch
export-reciprocal_value-for-modules.patch
sky2-avoid-divide-in-receive-path.patch
sky2-118.patch
skge-remove-broken-and-unused-phy_m_pc_mdi_xmode-macro.patch
sky2-restore-multicast-list-on-resume-and-other-ops.patch
git-net.patch
