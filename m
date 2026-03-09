Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA24D4CB5B
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 19:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773083791; cv=none; b=KL5fmLFHZnrSug5x/Qnhn98tYmDc6QXKmETWHwrobMGY1cgUQRuYcSVAQkEPp2dOvcv4TagBCZ3guEu5ZGI6Ldz9o2XgAYymEC+hTZeOglmHqOZiTE77AuTexV430obgXaZlCMSWHERnRKeRMOpV7C1Cb/0yP/9AmwvMd3YPhlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773083791; c=relaxed/simple;
	bh=qgQlSBUcyvT+mFysFpRtwZtpr9zNfBrXAanKU4ClDeI=;
	h=Date:To:From:Subject:Message-Id; b=RCWKeapbM4hg9eGBb10DFWD9Ot/6HuKCPxioGqEa3dI1Ta4Se/dfQ1Mm/cOf8r+5EYwMBe2jAkFwyKH9/samEYEHiv5ZOX8un9CoXa3912zmxgYH1h2/KGwOng87fVhtkGA65sj3wTaz4Jaqcap0/8K0SzQz0OTTu30oGzd4jns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y7Yu+Uik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y7Yu+Uik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4BAC4CEF7;
	Mon,  9 Mar 2026 19:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773083790;
	bh=qgQlSBUcyvT+mFysFpRtwZtpr9zNfBrXAanKU4ClDeI=;
	h=Date:To:From:Subject:From;
	b=y7Yu+UikpMlBIG2/JvSP9EjuBCncx4AjPA9b9IbA0txAJ5VniHIELcyNjaIkGHxPA
	 2a/Jm7vcDfMM+TYPIBGLzIKx0D5EzW050F42cR+sNxOE8HN9mjvDd4yC/S5G3hGfra
	 /gLQ3Mkq2sZN6xpB5yEPn+NBA/6gngU5OotP2t9s=
Date: Mon, 09 Mar 2026 12:16:31 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,liam.howlett@oracle.com,jason@zx2c4.com,jannh@google.com,david@kernel.org,anthony.yznaga@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-prevent-droppable-mappings-from-being-locked-fix-fix.patch removed from -mm tree
Message-Id: <20260309191630.AC4BAC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-prevent-droppable-mappings-from-being-locked-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-prevent-droppable-mappings-from-being-locked-fix-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-prevent-droppable-mappings-from-being-locked-fix-fix
Date: Sun Mar  8 10:28:48 PM PDT 2026

fix non-ascii junk from email demessification

Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/include/dup.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/vma/include/dup.h~mm-prevent-droppable-mappings-from-being-locked-fix-fix
+++ a/tools/testing/vma/include/dup.h
@@ -351,7 +351,7 @@ enum {
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
 /* This mask prevents VMAs from being mlock'd */
-#define VM_NO_MLOCK_MASK       (VM_SPECIAL | VM_DROPPABLE)
+#define VM_NO_MLOCK_MASK	(VM_SPECIAL | VM_DROPPABLE)
 
 #define TASK_EXEC ((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
maple_tree-add-cp_is_new_root-helper-fix-fix.patch
mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix.patch
mm-rename-zone-lock-to-zone-_lock-fix.patch
mm-page_reporting-add-page_reporting_order_unspecified-fix.patch
kernel-panic-increase-buffer-size-for-verbose-taint-logging-fix.patch

