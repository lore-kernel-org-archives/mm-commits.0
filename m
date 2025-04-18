Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CF72517A8;
	Fri, 18 Apr 2025 03:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945877; cv=none; b=ObSh7/p1UurUp65OYi6hs4nfS+crVAUJ+EQOPW+HKrGvCVs4+rWg2Mkvuhq9ai9vgk47iJxPX2aswRw92JyZz2Y4h7Nt+Df3Lu7BtRekI/2AhbUEhUI0Zo2JAF6eYexm7Yy+9yf0hntQqaPllhrllLStcEAm624h45SCnvrsMmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945877; c=relaxed/simple;
	bh=9WIXVR9S4B+gf39XWUtGVrQkZPZBFOVQ3Usb/Trw6uU=;
	h=Date:To:From:Subject:Message-Id; b=LUIIo60nkynDm/Ni0aCyItX5dwYdeQ6dNDWJn7tg/OFXevK8aYRGo8kSXwZ3o0Oc65nBnZMSU2wKqVj+OMS9c5GDEUfGSNjZIcIijFA/PlChoJCnQYh3lHdJdwuQDs9OP4NYz+uoChKg+iJERW1OEnMQuTGTQJjj1pCkNBOrc/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xx1tkXLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xx1tkXLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB65C4CEE4;
	Fri, 18 Apr 2025 03:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945875;
	bh=9WIXVR9S4B+gf39XWUtGVrQkZPZBFOVQ3Usb/Trw6uU=;
	h=Date:To:From:Subject:From;
	b=xx1tkXLWYRWTlyAw7Sbi1u3tNIEafe5mdN0wb0MM7VSVhtIvltArNiQoNIPAHD9Wu
	 eUmdTd5MABqJh+Fs29Bcv8iefUCqa8R4Yp6V6A4LYEtQtgZwpdkwz1972/7IVHuO1S
	 Y2ClxoTGk3GXBDq3kkJf95Ahw6HJ6aGi15vkEdWI=
Date: Thu, 17 Apr 2025 20:11:14 -0700
To: mm-commits@vger.kernel.org,yanjun.zhu@linux.dev,stable@vger.kernel.org,osalvador@suse.de,david@redhat.com,agruenba@redhat.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch removed from -mm tree
Message-Id: <20250418031114.DEB65C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()
Date: Thu, 10 Apr 2025 11:57:14 +0800

Not like fault_in_readable() or fault_in_writeable(), in
fault_in_safe_writeable() local variable 'start' is increased page by page
to loop till the whole address range is handled.  However, it mistakenly
calculates the size of the handled range with 'uaddr - start'.

Fix it here.

Andreas said:

: In gfs2, fault_in_iov_iter_writeable() is used in
: gfs2_file_direct_read() and gfs2_file_read_iter(), so this potentially
: affects buffered as well as direct reads.  This bug could cause those
: gfs2 functions to spin in a loop.

Link: https://lkml.kernel.org/r/20250410035717.473207-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20250410035717.473207-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Fixes: fe673d3f5bf1 ("mm: gup: make fault_in_safe_writeable() use fixup_user_fault()")
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Yanjun.Zhu <yanjun.zhu@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-fix-wrongly-calculated-returned-value-in-fault_in_safe_writeable
+++ a/mm/gup.c
@@ -2207,8 +2207,8 @@ size_t fault_in_safe_writeable(const cha
 	} while (start != end);
 	mmap_read_unlock(mm);
 
-	if (size > (unsigned long)uaddr - start)
-		return size - ((unsigned long)uaddr - start);
+	if (size > start - (unsigned long)uaddr)
+		return size - (start - (unsigned long)uaddr);
 	return 0;
 }
 EXPORT_SYMBOL(fault_in_safe_writeable);
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-gup-remove-unneeded-checking-in-follow_page_pte.patch
mm-gup-remove-gup_fast_pgd_leaf-and-clean-up-the-relevant-codes.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions.patch
mm-gup-clean-up-codes-in-fault_in_xxx-functions-v5.patch

