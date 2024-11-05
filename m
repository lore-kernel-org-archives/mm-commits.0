Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC8836127
	for <mm-commits@vger.kernel.org>; Tue,  5 Nov 2024 03:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730778607; cv=none; b=Ejo+DgHedpgfOeJV+bMisYXgPJ9picOix/fEXHGn3wFmZt+NYTrMLP8LbcxOjlsnhf1r5VY7OG1gZNjuFCKhdYvn+tseFDL6XaWfJEYkwkTziXHzVPHcyITl49zUDbmQIAu3KXZck6hs+sVCumgZzxQPwfiD57LKjAYCU+RYGjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730778607; c=relaxed/simple;
	bh=31cw4OxpchkJ7OZ/tyRpeJ56vadrT3/L0+8pl3amuhY=;
	h=Date:To:From:Subject:Message-Id; b=EkX2BP5THRvo53HvSs6jH2mJb9sRw402Z5Pu0XbCYFCDoxyR7k3V4x791WZDX2J5E+wi6r6JcauC+bVQ8UVecxpflhBhnUI3MvhS3o8kjkxz6aasquwDRYX0eNSeZp8u3TVGtmO0g7AasXHpLRNuDl4six3epq2XkQoMNCdsxUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kEer/2uw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kEer/2uw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3965C4CECF;
	Tue,  5 Nov 2024 03:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730778606;
	bh=31cw4OxpchkJ7OZ/tyRpeJ56vadrT3/L0+8pl3amuhY=;
	h=Date:To:From:Subject:From;
	b=kEer/2uwiV+BeXektkxPm+WAN+60dj8LRjGHU0ay1yjzAA29zRRW7vquFlivI2IO3
	 KbfZJepmbsLn2s+fM7Z75fzutypludy6K7uZfH29j7hbR6d5WSzLWVpANKUp8WW94Y
	 XeGqfN8OT+aSXL48VdQpNhmbXyIZFOk6QnSflcUk=
Date: Mon, 04 Nov 2024 19:50:06 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-memory-management-add-document-files-for-mm.patch added to mm-unstable branch
Message-Id: <20241105035006.B3965C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS/MEMORY MANAGEMENT: add document files for mm
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-memory-management-add-document-files-for-mm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-memory-management-add-document-files-for-mm.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: MAINTAINERS/MEMORY MANAGEMENT: add document files for mm
Date: Fri, 1 Nov 2024 13:23:10 -0700

Memory managment subsystem documents ('admin-guide/mm/' and 'mm/' under
'Documentation/') are not marked as managed under memory management
subsystem.  This makes 'get_maintainer.pl' for changes to the documents
sub-optimal.  Mark the documents as part of mm subsystem on MAINTAINERS
file.

Link: https://lkml.kernel.org/r/20241101202311.53935-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-memory-management-add-document-files-for-mm
+++ a/MAINTAINERS
@@ -14848,6 +14848,8 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
+F:	Documentation/admin-guide/mm/
+F:	Documentation/mm/
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
 F:	include/linux/memfd.h
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-zero-aggregationops_update-intervals.patch
mm-damon-core-handle-zero-schemes-apply-interval.patch
mm-damon-core-avoid-overflow-in-damon_feed_loop_next_input.patch
selftests-damon-huge_count_read_write-remove-unnecessary-debugging-message.patch
selftests-damon-_debugfs_common-hide-expected-error-message-from-test_write_result.patch
selftests-damon-debugfs_duplicate_context_creation-hide-errors-from-expected-file-write-failures.patch
mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch
mm-damon-tests-dbgfs-kunit-fix-the-header-double-inclusion-guarding-ifdef-comment.patch
docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch
maintainers-memory-management-add-document-files-for-mm.patch

