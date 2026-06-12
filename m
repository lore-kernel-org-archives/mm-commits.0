Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429B21E515
	for <mm-commits@vger.kernel.org>; Fri, 12 Jun 2026 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781291208; cv=none; b=H3PWsikBqcK1gAnnRv1vNPWpEXvM4T31ahxhKiPqdGAoob/Yg5md2+fM1Rea3Pve9jUankb8/h93bcu3IVvIbr5xiw+VWT900dxPmFlmcB1JdBUScw/9ADvYZ+9vQvqe1h9VS+IppvPfIi0tsO8zvB493xroRU+P+ZCSTCbovgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781291208; c=relaxed/simple;
	bh=/3FPoHDFWG/msiJHE7jCTDoKsS0jDbvuhbmZCFHgwto=;
	h=Date:To:From:Subject:Message-Id; b=einVnY9sJ17XdpiyIhiINKrAhDRPw7C+hNfY2tAPFSO6VfsyJ6amm/AqC6FB0IZJwiivz2diadknVYfk1/yvXaKBi0CKKpWIttBLZda/PuqiIuyi7DRtUE229tQqR2vwFDVZMiWvfqy4pu6Sh+u/MtJ9+wQoCeGw6bcpkX3pj7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2wiVeDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2wiVeDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76311F000E9;
	Fri, 12 Jun 2026 19:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781291206;
	bh=YQTXS3xzn8EFQWko0RhZmAeNHd/JtFETmRirBs/IxJM=;
	h=Date:To:From:Subject;
	b=N2wiVeDPRbMW7QoSYL1p5QSHYRAqw8RWO9kxl6wND5A3YccXgYlo1hnoxP1mMT4Q8
	 Z6b3u9pqeY/h8L8bDPd4EF1QrAcX7PFO9Imqi60JS1R69rEHZ2HzmMtTtNif/zFbYB
	 rNTkDYMBLKcaV0KlYRNO1nIWhjWtIF2osJ8VZk5o=
Date: Fri, 12 Jun 2026 12:06:46 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,joe@perches.com,akpm@linux-foundation.org,iamsharduld@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + treewide-fix-transposed-sign-typos-and-update-spellingtxt.patch added to mm-nonmm-unstable branch
Message-Id: <20260612190646.B76311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: treewide: fix transposed "sign" typos and update spelling.txt
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     treewide-fix-transposed-sign-typos-and-update-spellingtxt.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/treewide-fix-transposed-sign-typos-and-update-spellingtxt.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Shardul Deshpande <iamsharduld@gmail.com>
Subject: treewide: fix transposed "sign" typos and update spelling.txt
Date: Fri, 12 Jun 2026 23:46:32 +0530

Several comments transpose the letters in "assigned" and "unsigned",
spelling them with "sing" instead of "sign".  Correct all of them.

Of these, the misspelling of "assigned" is not yet flagged by checkpatch,
so also add it to scripts/spelling.txt.

The remaining matches of `grep -ri singed` are RISINGEDGE register and
enum names, not typos.

Link: https://lore.kernel.org/20260612181633.734458-1-iamsharduld@gmail.com
Signed-off-by: Shardul Deshpande <iamsharduld@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi |    2 +-
 drivers/gpu/drm/drm_color_mgmt.c           |    2 +-
 drivers/scsi/elx/efct/efct_hw.h            |    2 +-
 drivers/scsi/isci/host.c                   |    2 +-
 drivers/scsi/isci/port.c                   |    2 +-
 drivers/scsi/isci/port_config.c            |    2 +-
 kernel/bpf/helpers.c                       |    2 +-
 scripts/spelling.txt                       |    1 +
 8 files changed, 8 insertions(+), 7 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi~treewide-fix-transposed-sign-typos-and-update-spellingtxt
+++ a/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi
@@ -562,7 +562,7 @@ mos_bt_uart: &uart7 {
  *
  * This has entries that are defined by Qcard even if they go to the main
  * board. In cases where the pulls may be board dependent we defer those
- * settings to the board device tree. Drive strengths tend to be assinged here
+ * settings to the board device tree. Drive strengths tend to be assigned here
  * but could conceivably be overwridden by board device trees.
  */
 
--- a/drivers/gpu/drm/drm_color_mgmt.c~treewide-fix-transposed-sign-typos-and-update-spellingtxt
+++ a/drivers/gpu/drm/drm_color_mgmt.c
@@ -54,7 +54,7 @@
  *	&drm_crtc_state.degamma_lut.
  *
  * “DEGAMMA_LUT_SIZE”:
- *	Unsinged range property to give the size of the lookup table to be set
+ *	Unsigned range property to give the size of the lookup table to be set
  *	on the DEGAMMA_LUT property (the size depends on the underlying
  *	hardware). If drivers support multiple LUT sizes then they should
  *	publish the largest size, and sub-sample smaller sized LUTs (e.g. for
--- a/drivers/scsi/elx/efct/efct_hw.h~treewide-fix-transposed-sign-typos-and-update-spellingtxt
+++ a/drivers/scsi/elx/efct/efct_hw.h
@@ -59,7 +59,7 @@
 #define EFCT_HW_EQ_DEPTH		1024
 
 /*
- * A CQ will be assinged to each WQ
+ * A CQ will be assigned to each WQ
  * (CQ must have 2X entries of the WQ for abort
  * processing), plus a separate one for each RQ PAIR and one for MQ
  */
--- a/drivers/scsi/isci/host.c~treewide-fix-transposed-sign-typos-and-update-spellingtxt
+++ a/drivers/scsi/isci/host.c
@@ -2488,7 +2488,7 @@ struct isci_request *sci_request_by_tag(
  *    free remote node ids
  * @idev: This is the device object which is requesting the a remote node
  *    id
- * @node_id: This is the remote node id that is assinged to the device if one
+ * @node_id: This is the remote node id that is assigned to the device if one
  *    is available
  *
  * enum sci_status SCI_FAILURE_OUT_OF_RESOURCES if there are no available remote
--- a/drivers/scsi/isci/port.c~treewide-fix-transposed-sign-typos-and-update-spellingtxt
+++ a/drivers/scsi/isci/port.c
@@ -464,7 +464,7 @@ static enum sci_status sci_port_set_phy(
 {
 	/* Check to see if we can add this phy to a port
 	 * that means that the phy is not part of a port and that the port does
-	 * not already have a phy assinged to the phy index.
+	 * not already have a phy assigned to the phy index.
 	 */
 	if (!iport->phy_table[iphy->phy_index] &&
 	    !phy_get_non_dummy_port(iphy) &&
--- a/drivers/scsi/isci/port_config.c~treewide-fix-transposed-sign-typos-and-update-spellingtxt
+++ a/drivers/scsi/isci/port_config.c
@@ -259,7 +259,7 @@ sci_mpc_agent_validate_phy_configuration
 		if (!phy_mask)
 			continue;
 		/*
-		 * Make sure that one or more of the phys were not already assinged to
+		 * Make sure that one or more of the phys were not already assigned to
 		 * a different port. */
 		if ((phy_mask & ~assigned_phy_mask) == 0) {
 			return SCI_FAILURE_UNSUPPORTED_PORT_CONFIGURATION;
--- a/kernel/bpf/helpers.c~treewide-fix-transposed-sign-typos-and-update-spellingtxt
+++ a/kernel/bpf/helpers.c
@@ -3601,7 +3601,7 @@ __bpf_kfunc int bpf_copy_from_user_task_
 	return ret + 1;
 }
 
-/* Keep unsinged long in prototype so that kfunc is usable when emitted to
+/* Keep unsigned long in prototype so that kfunc is usable when emitted to
  * vmlinux.h in BPF programs directly, but note that while in BPF prog, the
  * unsigned long always points to 8-byte region on stack, the kernel may only
  * read and write the 4-bytes on 32-bit.
--- a/scripts/spelling.txt~treewide-fix-transposed-sign-typos-and-update-spellingtxt
+++ a/scripts/spelling.txt
@@ -176,6 +176,7 @@ assgined||assigned
 assiged||assigned
 assigment||assignment
 assigments||assignments
+assinged||assigned
 assistent||assistant
 assocaited||associated
 assocated||associated
_

Patches currently in -mm which might be from iamsharduld@gmail.com are

treewide-fix-transposed-sign-typos-and-update-spellingtxt.patch

