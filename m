Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F9A1F92E
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 02:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759976100; cv=none; b=n1ZS+7IE+2lYj7U19UM0u6FemmuROkTjPV8tpdD5ya22v1JZ5nSKAry1YMqQPkLb/tU8hnuxfhoEmKDlwCcBJber1uASgtwLuh0XywgBodUgbV4i2B3QPsF2mu7+sYuyXH4SJAEa/rdVm94Xwb74jQwH6DjnooR/TO4eVuw3cDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759976100; c=relaxed/simple;
	bh=1R1qUycDHLIcQL1wcvWM/l6cr/kfYbfDgeNUy2lFUL0=;
	h=Date:To:From:Subject:Message-Id; b=l7KC5B1jnZytTx2Nc8BCtnKepbNzk9p//GWXSyu+d237UyrUuvAOIuB0+9cPQIN+at4Xcvh/h4WcP3s1sL19aSrKQxp3D/ZhnARyJzXd103UADdzPvB/PmaykQL/lph6BuRwhcV0nJw5AY6u27xz0vA+PkiT0BzTA1QfVW6jrhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=knXv0UcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="knXv0UcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADD4C4CEE7;
	Thu,  9 Oct 2025 02:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759976099;
	bh=1R1qUycDHLIcQL1wcvWM/l6cr/kfYbfDgeNUy2lFUL0=;
	h=Date:To:From:Subject:From;
	b=knXv0UcIM6gRkqAvoRv6rNtH4lypCApi/g5laLDBqUMqdPcopVRWulRf8zfQySb35
	 nVCsI4mc+EpaEhWh08PH9nRovTuiKSbWN7JNrBRPaxWWBQiQZYzADnqtC5bdI7iHMg
	 AdvaZumng7oMRmIxqm3rFP1Swgekv4kTgEXdeOng=
Date: Wed, 08 Oct 2025 19:14:58 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,pratyush@kernel.org,ojeda@kernel.org,masahiroy@kernel.org,jgg@ziepe.ca,jgg@nvidia.com,graf@amazon.com,corbet@lwn.net,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-allow-to-drive-kho-from-within-kernel.patch added to mm-nonmm-unstable branch
Message-Id: <20251009021459.6ADD4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: allow to drive kho from within kernel
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-allow-to-drive-kho-from-within-kernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-allow-to-drive-kho-from-within-kernel.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: allow to drive kho from within kernel
Date: Tue, 7 Oct 2025 03:30:54 +0000

Patch series "liveupdate: Rework KHO for in-kernel users", v5.

These patches are taken from the LUOv4 series [1] and address recent
comments from Pratyush.

This series refactors the KHO framework to better support in-kernel users
like the upcoming LUO.  The current design, which relies on a notifier
chain and debugfs for control, is too restrictive for direct programmatic
use.

The core of this rework is the removal of the notifier chain in favor of a
direct registration API.  This decouples clients from the shutdown-time
finalization sequence, allowing them to manage their preserved state more
flexibly and at any time.

In support of this new model, this series also:
 - Exports kho_finalize() and kho_abort() for programmatic control.
 - Makes the debugfs interface optional.
 - Introduces APIs to unpreserve memory and fixes a bug in the abort
   path where client state was being incorrectly discarded. Note that
   this is an interim step, as a more comprehensive fix is planned as
   part of the stateless KHO work [2].
 - Moves all KHO code into a new kernel/liveupdate/ directory to
   consolidate live update components.


This patch (of 7):

Allow to do finalize and abort from kernel modules, so LUO could drive the
KHO sequence via its own state machine.

Link: https://lkml.kernel.org/r/20251007033100.836886-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20251007033100.836886-2-pasha.tatashin@soleen.com
Link: https://lore.kernel.org/all/20250929010321.3462457-1-pasha.tatashin@soleen.com [1]
Link: https://lore.kernel.org/all/20251001011941.1513050-1-jasonmiu@google.com [2]
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec_handover.h |   15 ++++++
 kernel/kexec_handover.c        |   74 ++++++++++++++++++-------------
 2 files changed, 59 insertions(+), 30 deletions(-)

--- a/include/linux/kexec_handover.h~kho-allow-to-drive-kho-from-within-kernel
+++ a/include/linux/kexec_handover.h
@@ -67,6 +67,10 @@ void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
+
+int kho_finalize(void);
+int kho_abort(void);
+
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -139,6 +143,17 @@ static inline void kho_populate(phys_add
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
 }
+
+static inline int kho_finalize(void)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int kho_abort(void)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #endif /* LINUX_KEXEC_HANDOVER_H */
--- a/kernel/kexec_handover.c~kho-allow-to-drive-kho-from-within-kernel
+++ a/kernel/kexec_handover.c
@@ -1067,7 +1067,7 @@ static int kho_out_update_debugfs_fdt(vo
 	return err;
 }
 
-static int kho_abort(void)
+static int __kho_abort(void)
 {
 	int err;
 	unsigned long order;
@@ -1100,7 +1100,27 @@ static int kho_abort(void)
 	return err;
 }
 
-static int kho_finalize(void)
+int kho_abort(void)
+{
+	int ret = 0;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	guard(mutex)(&kho_out.lock);
+	if (!kho_out.finalized)
+		return -ENOENT;
+
+	ret = __kho_abort();
+	if (ret)
+		return ret;
+
+	kho_out.finalized = false;
+
+	return kho_out_update_debugfs_fdt();
+}
+
+static int __kho_finalize(void)
 {
 	int err = 0;
 	u64 *preserved_mem_map;
@@ -1143,12 +1163,32 @@ static int kho_finalize(void)
 abort:
 	if (err) {
 		pr_err("Failed to convert KHO state tree: %d\n", err);
-		kho_abort();
+		__kho_abort();
 	}
 
 	return err;
 }
 
+int kho_finalize(void)
+{
+	int ret;
+
+	if (!kho_enable)
+		return -EOPNOTSUPP;
+
+	guard(mutex)(&kho_out.lock);
+	if (kho_out.finalized)
+		return -EEXIST;
+
+	ret = __kho_finalize();
+	if (ret)
+		return ret;
+
+	kho_out.finalized = true;
+
+	return kho_out_update_debugfs_fdt();
+}
+
 static int kho_out_finalize_get(void *data, u64 *val)
 {
 	mutex_lock(&kho_out.lock);
@@ -1160,33 +1200,7 @@ static int kho_out_finalize_get(void *da
 
 static int kho_out_finalize_set(void *data, u64 _val)
 {
-	int ret = 0;
-	bool val = !!_val;
-
-	mutex_lock(&kho_out.lock);
-
-	if (val == kho_out.finalized) {
-		if (kho_out.finalized)
-			ret = -EEXIST;
-		else
-			ret = -ENOENT;
-		goto unlock;
-	}
-
-	if (val)
-		ret = kho_finalize();
-	else
-		ret = kho_abort();
-
-	if (ret)
-		goto unlock;
-
-	kho_out.finalized = val;
-	ret = kho_out_update_debugfs_fdt();
-
-unlock:
-	mutex_unlock(&kho_out.lock);
-	return ret;
+	return (!!_val) ? kho_finalize() : kho_abort();
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(fops_kho_out_finalize, kho_out_finalize_get,
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

kho-allow-to-drive-kho-from-within-kernel.patch
kho-make-debugfs-interface-optional.patch
kho-add-interfaces-to-unpreserve-folios-and-page-ranes.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
kho-move-kho-debugfs-directory-to-liveupdate.patch

