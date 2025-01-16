Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEE8156C5E
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737005959; cv=none; b=Kp79Ax2pbPPbbWGKzfoOviZHb6e+OPCZk+COsAmvyD9daCFAw+amxOdbOGygOCGhdj50j041OFoV7Z7P+mgOVpA3o2k4DykMEHiR7cOP0/gWjv4dx7Zm0d4P/onh2WWe24BovaNUP7NbrIXw+gYK+4ZqE/tAfl7XkDNyN238UEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737005959; c=relaxed/simple;
	bh=zP7rR5erUcDvtUL4iy6p1ltWyR2UCAm+47VgGRy6aJ0=;
	h=Date:To:From:Subject:Message-Id; b=uhAdljleBfu1C9HOUs09D3WoDdEC1kcpti8gOGsqrSA1SmT+KVX1SLoEKiHyY7+LIngwrbttebmCWF+fpV7bAeJI09fl5j+HpHLn91ZH9VBnYqBSlXQVbGQ8AFfHpUr9RXDiPv7NWO1rSFw6/8Z0XkugKXwknvCx4am0D61LZ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o8OEA+VR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o8OEA+VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71103C4CED6;
	Thu, 16 Jan 2025 05:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737005959;
	bh=zP7rR5erUcDvtUL4iy6p1ltWyR2UCAm+47VgGRy6aJ0=;
	h=Date:To:From:Subject:From;
	b=o8OEA+VRr/MVdetSSpys0YKJnv+CP3iJWQ3j5eVEm2wAD/BZ/ol+QiVwwBOYYyiDy
	 q9ZZoJORpY4++kiadXC0GWFpTVBfxIcfilDlgH3Qo6SSXUPhT88EKFtr1byf8HK/JD
	 8aHVXWOZpcm+sUTORZtwSRo7RMsk/ApXRF/a2/t4=
Date: Wed, 15 Jan 2025 21:39:18 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ksm-add-ksm-involvement-information-for-each-process-fix.patch removed from -mm tree
Message-Id: <20250116053919.71103C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ksm-add-ksm-involvement-information-for-each-process-fix
has been removed from the -mm tree.  Its filename was
     ksm-add-ksm-involvement-information-for-each-process-fix.patch

This patch was dropped because it was folded into ksm-add-ksm-involvement-information-for-each-process.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ksm-add-ksm-involvement-information-for-each-process-fix
Date: Mon Jan 13 06:48:34 PM PST 2025

wording tweaks, per David and akpm

Cc: David Hildenbrand <david@redhat.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/Documentation/filesystems/proc.rst~ksm-add-ksm-involvement-information-for-each-process-fix
+++ a/Documentation/filesystems/proc.rst
@@ -2257,10 +2257,10 @@ Description
 ksm_rmap_items
 ^^^^^^^^^^^^^^
 
-The number of ksm_rmap_item structure in use. The structure of
-ksm_rmap_item is to store the reverse mapping information for virtual
-addresses. KSM will generate a ksm_rmap_item for each ksm-scanned page
-of the process.
+The number of ksm_rmap_item structures in use.  The structure
+ksm_rmap_item stores the reverse mapping information for virtual
+addresses.  KSM will generate a ksm_rmap_item for each ksm-scanned page of
+the process.
 
 ksm_zero_pages
 ^^^^^^^^^^^^^^
@@ -2289,14 +2289,16 @@ ksm_merge_any
 ^^^^^^^^^^^^^
 
 It specifies whether the process'mm is added by prctl() into the candidate list
-of KSM or not, and KSM scanning is fully enabled at process level.
+of KSM or not, and if KSM scanning is fully enabled at process level.
 
 ksm_mergeable
 ^^^^^^^^^^^^^
 
-It specifies whether any VMAs of the process'mm are currently applicable to KSM.
+It specifies whether any VMAs of the process'mm are currently applicable
+to KSM.
 
-More information about KSM can be found at Documentation/admin-guide/mm/ksm.rst.
+More information about KSM can be found in
+Documentation/admin-guide/mm/ksm.rst.
 
 
 Chapter 4: Configuring procfs
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ksm-add-ksm-involvement-information-for-each-process.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch

