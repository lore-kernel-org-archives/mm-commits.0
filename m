Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465EC57CBB
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 19:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059934; cv=none; b=SNcgWHU6c2c1a00+9Vl3vgfoYwsITVJdX94Xx1r+23qZ1iqws9aIdOQ5GwCD2bI4Zk3CAKDfTa0o1auGBpM3/d9U1L7vZKKxVQqx5kn032b0YwlP31MsGDGtZi1ZtihRc+Cs+m/+Qt7daYr9dBqd866BCLnzizBGhRV/x10Oe44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059934; c=relaxed/simple;
	bh=HSF+oIj0wVkeRq3uG4uXq9l33wPBASAWIPEyYRv42Y0=;
	h=Date:To:From:Subject:Message-Id; b=TFLQfNBrM/fv76xJNYxuDQQ5X71B4sqmBMMK7VOuht5WPBgp4YwoJNrljkrAoLV+h80ZS4f3CsDp6HV633y7QJi1HnhKzIxqYqqSTIYMxsKaf3s7+l4uO2gA0o+fzsBpNO50plreSvSyZb06ro3m0vnYqGFQKp+UQV1bXFwTJrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jjf3FoHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jjf3FoHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BC8C32781;
	Wed,  7 Aug 2024 19:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723059933;
	bh=HSF+oIj0wVkeRq3uG4uXq9l33wPBASAWIPEyYRv42Y0=;
	h=Date:To:From:Subject:From;
	b=jjf3FoHo3GlohzBDHJpLetA6dTohvv2CKlbkYuZtPv+oZUR/NgEwXtziVfZ1WR/zG
	 aX1ENTXcgCLUL0mVqkw44n0uVFDKcBgLK7ldlko9xhN1D0CtJkWybAHZeR3R/nOTjf
	 bcT2VNiFuaG4jJ19sqhyLIlSZAJ9NS01EwMs6gEI=
Date: Wed, 07 Aug 2024 12:45:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shuah@kernel.org,rmoar@google.com,pengfei.xu@intel.com,Liam.Howlett@oracle.com,kees@kernel.org,jack@suse.cz,ebiederm@xmission.com,davidgow@google.com,brendanhiggins@google.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch added to mm-unstable branch
Message-Id: <20240807194533.B5BC8C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: userfaultfd: fix user-after-free in userfaultfd_clear_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: userfaultfd: fix user-after-free in userfaultfd_clear_vma()
Date: Wed, 7 Aug 2024 12:44:27 +0100

After invoking vma_modify_flags_uffd() in userfaultfd_clear_vma(), we may
have merged the vma, and depending on the kind of merge, deleted the vma,
rendering the vma pointer invalid.

The code incorrectly referenced this now possibly invalid vma pointer when
invoking userfaultfd_reset_ctx().

If no merge is possible, vma_modify_flags_uffd() performs a split and
returns the original vma.  Therefore the correct approach is to simply
pass the ret pointer to userfaultfd_ret_ctx().

Link: https://lkml.kernel.org/r/3c947ddc-b804-49b7-8fe9-3ea3ca13def5@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Closes: https://lore.kernel.org/all/ZrLt9HIxV9QiZotn@xpf.sh.intel.com/
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rae Moar <rmoar@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix
+++ a/mm/userfaultfd.c
@@ -1813,7 +1813,7 @@ struct vm_area_struct *userfaultfd_clear
 	 * the current one has not been updated yet.
 	 */
 	if (!IS_ERR(ret))
-		userfaultfd_reset_ctx(vma);
+		userfaultfd_reset_ctx(ret);
 
 	return ret;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc-fix.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch

