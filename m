Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A168717573
	for <mm-commits@vger.kernel.org>; Wed, 12 Jun 2024 19:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718219737; cv=none; b=G4Oy/l+yuy8MRT5XXkVEy4xl/mGgxOAFc7ehkOB42D9SuHlMQBc+YiXp436X3/Ej1D21rnaQjU0Kk4aco3zAXak3cW+rzVqkNEmlR0g9lkQ1acLssAwKfRLSv0yCYQP49NcUh4vuKgAI1ewwslSYJ0zfYGMnKG4R3e7ZU6n1LVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718219737; c=relaxed/simple;
	bh=56ue/ry/Lpl1p7Ck3se/FHUh9g2eBLCzGa8TOlQgCDI=;
	h=Date:To:From:Subject:Message-Id; b=A60bmx2rwbjY2irreSuus1T0i+1cT/R57UYra8uMOEKtReCINLiinEeOf4RY1giFaHOISvqVDvmeRSIs/B4jcOV6amr1vYpFmzvtPEtgVOzAkDiOG+n/bxrgFMnecmruBttHb0xImr61OSlX8x0w/0s2o4L1yyuj2JovGCTqpgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DrDBzl7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DrDBzl7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEFDC116B1;
	Wed, 12 Jun 2024 19:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718219737;
	bh=56ue/ry/Lpl1p7Ck3se/FHUh9g2eBLCzGa8TOlQgCDI=;
	h=Date:To:From:Subject:From;
	b=DrDBzl7tN28/Fvy8xtIEgPNygYyugNvpzDXu4JRkREo7kRmj/k+mRSDuA5T4r0C2H
	 jUDKq/Pc3sqiv6f9EXYiQqcRCc0vDMfKOWtV+RUGGtKPTnd5FHDa6vrVElClJabvKU
	 xCGDA9eNl2sd5lWasxFZXvufqpOjKwQeY+YaYNyM=
Date: Wed, 12 Jun 2024 12:15:36 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,jesse.brandeburg@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-wide-fix-spelling-mistakes-like-assocative-associative.patch added to mm-nonmm-unstable branch
Message-Id: <20240612191537.0EEFDC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel-wide: fix spelling mistakes like "assocative" -> "associative"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-wide-fix-spelling-mistakes-like-assocative-associative.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-wide-fix-spelling-mistakes-like-assocative-associative.patch

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
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: kernel-wide: fix spelling mistakes like "assocative" -> "associative"
Date: Tue, 11 Jun 2024 17:12:22 -0700

There were several instances of the string "assocat" in the kernel, which
should have been spelled "associat", with the various endings of -ive,
-ed, -ion, and sometimes beginnging with dis-.

Add to the spelling dictionary the corrections so that future instances
will be caught by checkpatch, and fix the instances found.

Originally noticed by accident with a 'git grep socat'.

Link: https://lkml.kernel.org/r/20240612001247.356867-1-jesse.brandeburg@intel.com
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    2 +-
 drivers/net/wireless/ti/wl1251/acx.h           |    2 +-
 drivers/scsi/qedf/qedf_main.c                  |    2 +-
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c  |    2 +-
 drivers/staging/rtl8723bs/core/rtw_pwrctrl.c   |    2 +-
 include/linux/nvme-fc-driver.h                 |    2 +-
 include/linux/soc/apple/rtkit.h                |    4 ++--
 net/netfilter/nf_conntrack_core.c              |    2 +-
 net/tipc/socket.c                              |    2 +-
 scripts/spelling.txt                           |    3 +++
 10 files changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c~kernel-wide-fix-spelling-mistakes-like-assocative-associative
+++ a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -340,7 +340,7 @@ static int eb_create(struct i915_execbuf
 		 * Without a 1:1 association between relocation handles and
 		 * the execobject[] index, we instead create a hashtable.
 		 * We size it dynamically based on available memory, starting
-		 * first with 1:1 assocative hash and scaling back until
+		 * first with 1:1 associative hash and scaling back until
 		 * the allocation succeeds.
 		 *
 		 * Later on we use a positive lut_size to indicate we are
--- a/drivers/net/wireless/ti/wl1251/acx.h~kernel-wide-fix-spelling-mistakes-like-assocative-associative
+++ a/drivers/net/wireless/ti/wl1251/acx.h
@@ -229,7 +229,7 @@ struct acx_rx_msdu_lifetime {
  * ===		==========
  * 31:12		Reserved - Always equal to 0.
  * 11		Association - When set, the WiLink receives all association
- * 	 	related frames (association request/response, reassocation
+ *		related frames (association request/response, reassociation
  *		request/response, and disassociation). When clear, these frames
  *		are discarded.
  * 10		Auth/De auth - When set, the WiLink receives all authentication
--- a/drivers/scsi/qedf/qedf_main.c~kernel-wide-fix-spelling-mistakes-like-assocative-associative
+++ a/drivers/scsi/qedf/qedf_main.c
@@ -2286,7 +2286,7 @@ static bool qedf_process_completions(str
 		 * on.
 		 */
 		if (!io_req)
-			/* If there is not io_req assocated with this CQE
+			/* If there is not io_req associated with this CQE
 			 * just queue it on CPU 0
 			 */
 			cpu = 0;
--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c~kernel-wide-fix-spelling-mistakes-like-assocative-associative
+++ a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -979,7 +979,7 @@ unsigned int OnAssocReq(struct adapter *
 	left = pkt_len - (sizeof(struct ieee80211_hdr_3addr) + ie_offset);
 	pos = pframe + (sizeof(struct ieee80211_hdr_3addr) + ie_offset);
 
-	/*  check if this stat has been successfully authenticated/assocated */
+	/*  check if this stat has been successfully authenticated/associated */
 	if (!((pstat->state) & WIFI_FW_AUTH_SUCCESS)) {
 		if (!((pstat->state) & WIFI_FW_ASSOC_SUCCESS)) {
 			status = WLAN_REASON_CLASS2_FRAME_FROM_NONAUTH_STA;
--- a/drivers/staging/rtl8723bs/core/rtw_pwrctrl.c~kernel-wide-fix-spelling-mistakes-like-assocative-associative
+++ a/drivers/staging/rtl8723bs/core/rtw_pwrctrl.c
@@ -452,7 +452,7 @@ void LPS_Enter(struct adapter *padapter,
 	if (hal_btcoex_IsBtControlLps(padapter))
 		return;
 
-	/* Skip lps enter request if number of assocated adapters is not 1 */
+	/* Skip lps enter request if number of associated adapters is not 1 */
 	if (check_fwstate(&(dvobj->padapters->mlmepriv), WIFI_ASOC_STATE))
 		n_assoc_iface++;
 	if (n_assoc_iface != 1)
--- a/include/linux/nvme-fc-driver.h~kernel-wide-fix-spelling-mistakes-like-assocative-associative
+++ a/include/linux/nvme-fc-driver.h
@@ -620,7 +620,7 @@ enum {
  *
  * Structure used between LLDD and nvmet-fc layer to represent the exchange
  * context for a FC-NVME FCP I/O operation (e.g. a nvme sqe, the sqe-related
- * memory transfers, and its assocated cqe transfer).
+ * memory transfers, and its associated cqe transfer).
  *
  * The structure is allocated by the LLDD whenever a FCP CMD IU is received
  * from the FC link. The address of the structure is passed to the nvmet-fc
--- a/include/linux/soc/apple/rtkit.h~kernel-wide-fix-spelling-mistakes-like-assocative-associative
+++ a/include/linux/soc/apple/rtkit.h
@@ -69,7 +69,7 @@ struct apple_rtkit;
  * Initializes the internal state required to handle RTKit. This
  * should usually be called within _probe.
  *
- * @dev:         Pointer to the device node this coprocessor is assocated with
+ * @dev:         Pointer to the device node this coprocessor is associated with
  * @cookie:      opaque cookie passed to all functions defined in rtkit_ops
  * @mbox_name:   mailbox name used to communicate with the co-processor
  * @mbox_idx:    mailbox index to be used if mbox_name is NULL
@@ -83,7 +83,7 @@ struct apple_rtkit *devm_apple_rtkit_ini
  * Non-devm version of devm_apple_rtkit_init. Must be freed with
  * apple_rtkit_free.
  *
- * @dev:         Pointer to the device node this coprocessor is assocated with
+ * @dev:         Pointer to the device node this coprocessor is associated with
  * @cookie:      opaque cookie passed to all functions defined in rtkit_ops
  * @mbox_name:   mailbox name used to communicate with the co-processor
  * @mbox_idx:    mailbox index to be used if mbox_name is NULL
--- a/net/netfilter/nf_conntrack_core.c~kernel-wide-fix-spelling-mistakes-like-assocative-associative
+++ a/net/netfilter/nf_conntrack_core.c
@@ -1090,7 +1090,7 @@ static int nf_ct_resolve_clash_harder(st
  * A conntrack entry can be inserted to the connection tracking table
  * if there is no existing entry with an identical tuple.
  *
- * If there is one, @skb (and the assocated, unconfirmed conntrack) has
+ * If there is one, @skb (and the associated, unconfirmed conntrack) has
  * to be dropped.  In case @skb is retransmitted, next conntrack lookup
  * will find the already-existing entry.
  *
--- a/net/tipc/socket.c~kernel-wide-fix-spelling-mistakes-like-assocative-associative
+++ a/net/tipc/socket.c
@@ -657,7 +657,7 @@ static int tipc_release(struct socket *s
 }
 
 /**
- * __tipc_bind - associate or disassocate TIPC name(s) with a socket
+ * __tipc_bind - associate or disassociate TIPC name(s) with a socket
  * @sock: socket structure
  * @skaddr: socket address describing name(s) and desired operation
  * @alen: size of socket address data structure
--- a/scripts/spelling.txt~kernel-wide-fix-spelling-mistakes-like-assocative-associative
+++ a/scripts/spelling.txt
@@ -176,8 +176,10 @@ assigment||assignment
 assigments||assignments
 assistent||assistant
 assocaited||associated
+assocated||associated
 assocating||associating
 assocation||association
+assocative||associative
 associcated||associated
 assotiated||associated
 asssert||assert
@@ -543,6 +545,7 @@ direcly||directly
 direectly||directly
 diregard||disregard
 disassocation||disassociation
+disassocative||disassociative
 disapear||disappear
 disapeared||disappeared
 disappared||disappeared
_

Patches currently in -mm which might be from jesse.brandeburg@intel.com are

kernel-wide-fix-spelling-mistakes-like-assocative-associative.patch

