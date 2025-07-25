Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAA1BA3D;
	Fri, 25 Jul 2025 00:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753405113; cv=none; b=Elxz9TDZaYMY5gl1e5a/WU8YBncQ4JJawVjONHouyKJeBCzFa5AaZNP8phDpltpeY1ZbxMo76sTMAJZxcH1Cl8bEHt+hpB4titVGvZeE97MsKDZiUdz3Dy9BtA8Von3A57Bn4ISeXWUHsVNbTTiDbq1mMYV4u4yoGMoV9tPggIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753405113; c=relaxed/simple;
	bh=LreqLlbt4aArL7/PKDEilD8ZoX7Qrxl7L6FnAVhP3BI=;
	h=Date:To:From:Subject:Message-Id; b=jEEFNs0trJ4JJkMPpp/syP5thZTr2RvK5jMNrgmWyfFPGDMkSmYsjeEHswvluoAIls1hhOaFYWzNKc9fpnTdaV9oHvdZB05HfEFXt3Ok6h5cvbLm6Yad02MBFVhIFkNo6saSZncVDwcQOnwenBUQk/bqye3ICnVPTiHCK5qwypY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KJZGHhO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KJZGHhO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8098BC4CEEF;
	Fri, 25 Jul 2025 00:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753405112;
	bh=LreqLlbt4aArL7/PKDEilD8ZoX7Qrxl7L6FnAVhP3BI=;
	h=Date:To:From:Subject:From;
	b=KJZGHhO7jxorwCAVLNFLNQkyn+xgJ52Nblf7p2O6Nk5BZVV0sw+SqX5cVS0+GjSDM
	 kRj7dWHr4HoQe2/n00VoU07LaGaZgmHIPH1JShpWGhhNLJrCJE+tsFXaYcruimZf0V
	 eFF1p0fhxHgsgSu60k9oMTAe0hEFAcQsEbiidYoA=
Date: Thu, 24 Jul 2025 17:58:31 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,dan.j.williams@intel.com,akinobu.mita@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] resource-fix-false-warning-in-__request_region.patch removed from -mm tree
Message-Id: <20250725005832.8098BC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: resource: fix false warning in __request_region()
has been removed from the -mm tree.  Its filename was
     resource-fix-false-warning-in-__request_region.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: resource: fix false warning in __request_region()
Date: Sat, 19 Jul 2025 20:26:04 +0900

A warning is raised when __request_region() detects a conflict with a
resource whose resource.desc is IORES_DESC_DEVICE_PRIVATE_MEMORY.

But this warning is only valid for iomem_resources.
The hmem device resource uses resource.desc as the numa node id, which can
cause spurious warnings.

This warning appeared on a machine with multiple cxl memory expanders. 
One of the NUMA node id is 6, which is the same as the value of
IORES_DESC_DEVICE_PRIVATE_MEMORY.

In this environment it was just a spurious warning, but when I saw the
warning I suspected a real problem so it's better to fix it.

This change fixes this by restricting the warning to only iomem_resource.
This also adds a missing new line to the warning message.

Link: https://lkml.kernel.org/r/20250719112604.25500-1-akinobu.mita@gmail.com
Fixes: 7dab174e2e27 ("dax/hmem: Move hmem device registration to dax_hmem.ko")
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/resource.c~resource-fix-false-warning-in-__request_region
+++ a/kernel/resource.c
@@ -1279,8 +1279,9 @@ static int __request_region_locked(struc
 		 * become unavailable to other users.  Conflicts are
 		 * not expected.  Warn to aid debugging if encountered.
 		 */
-		if (conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
-			pr_warn("Unaddressable device %s %pR conflicts with %pR",
+		if (parent == &iomem_resource &&
+		    conflict->desc == IORES_DESC_DEVICE_PRIVATE_MEMORY) {
+			pr_warn("Unaddressable device %s %pR conflicts with %pR\n",
 				conflict->name, conflict, res);
 		}
 		if (conflict != parent) {
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are


