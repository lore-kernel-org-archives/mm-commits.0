Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778E078C93
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423557; cv=none; b=omxbq2jFUWQT1r3/ZIZRUZq48Pvj2R8cDRPamaiqh0jsau7btTX4HefeUUnq5qWc/yCbMInTavqJZYR79Dm5KhMemmP43hrw2mz/YBXSjFL46lwXKx+w/CWOa/axDiwFsNRYfYoBC8bPewGcKmpNhQcCXOvuez5WkZmv6HIOJsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423557; c=relaxed/simple;
	bh=gOasjdnJDCvpu3Yw44cznJG0233SpHILhWBeOZlToEo=;
	h=Date:To:From:Subject:Message-Id; b=PBMOH3h13xiMv9Zd8AEg3Wl/7ysrjJUjwbPxWexcMDhBH+3y/bPZkryBhn+O4WhCuirNsycA8zWQa9enT8xqT7oVzgLY0+5laYivkJHIHTadS/hNMUMqb+4UOTF6Cu0LGaucVB3M8TMCZRAW2YZZIuCQ4chK1oGOQLxwfM4XwH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N/t1skVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N/t1skVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F0EC4CEC2;
	Wed,  4 Sep 2024 04:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423557;
	bh=gOasjdnJDCvpu3Yw44cznJG0233SpHILhWBeOZlToEo=;
	h=Date:To:From:Subject:From;
	b=N/t1skVKbk5Zl8Gav3eFL5HUOJe2XTS/RTzW5GLeHSHckQUqi/yg/qcHz/AKTnsuZ
	 3twnw1IWMN8Tf22UJXC005owz0Dvj/G4KYYpPr2fcGch2l2fHEFnbpvxHFkVTX+S6g
	 JqRFkB5ukyfZS2WU7PtmAAzwzsBpcQlSETN0tXQs=
Date: Tue, 03 Sep 2024 21:19:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-extract-validate_mm-from-vma_complete.patch removed from -mm tree
Message-Id: <20240904041917.46F0EC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: extract validate_mm() from vma_complete()
has been removed from the -mm tree.  Its filename was
     mm-vma-extract-validate_mm-from-vma_complete.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: extract validate_mm() from vma_complete()
Date: Fri, 30 Aug 2024 00:00:47 -0400

vma_complete() will need to be called during an unsafe time to call
validate_mm().  Extract the call in all places now so that only one
location can be modified in the next change.

Link: https://lkml.kernel.org/r/20240830040101.822209-8-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 mm/vma.c  |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-vma-extract-validate_mm-from-vma_complete
+++ a/mm/mmap.c
@@ -1796,6 +1796,7 @@ static int do_brk_flags(struct vma_itera
 		vma_iter_store(vmi, vma);
 
 		vma_complete(&vp, vmi, mm);
+		validate_mm(mm);
 		khugepaged_enter_vma(vma, flags);
 		goto out;
 	}
--- a/mm/vma.c~mm-vma-extract-validate_mm-from-vma_complete
+++ a/mm/vma.c
@@ -269,6 +269,7 @@ static int __split_vma(struct vma_iterat
 
 	/* vma_complete stores the new vma */
 	vma_complete(&vp, vmi, vma->vm_mm);
+	validate_mm(vma->vm_mm);
 
 	/* Success. */
 	if (new_below)
@@ -548,6 +549,7 @@ int vma_expand(struct vma_iterator *vmi,
 	vma_iter_store(vmi, vma);
 
 	vma_complete(&vp, vmi, vma->vm_mm);
+	validate_mm(vma->vm_mm);
 	return 0;
 
 nomem:
@@ -589,6 +591,7 @@ int vma_shrink(struct vma_iterator *vmi,
 	vma_iter_clear(vmi);
 	vma_set_range(vma, start, end, pgoff);
 	vma_complete(&vp, vmi, vma->vm_mm);
+	validate_mm(vma->vm_mm);
 	return 0;
 }
 
@@ -668,7 +671,6 @@ again:
 	}
 	if (vp->insert && vp->file)
 		uprobe_mmap(vp->insert);
-	validate_mm(mm);
 }
 
 /*
@@ -1197,6 +1199,7 @@ static struct vm_area_struct
 	}
 
 	vma_complete(&vp, vmi, mm);
+	validate_mm(mm);
 	khugepaged_enter_vma(res, vm_flags);
 	return res;
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


