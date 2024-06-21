Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6BC13D521
	for <mm-commits@vger.kernel.org>; Fri, 21 Jun 2024 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989436; cv=none; b=cCS+CKQXyR8FCKuwdVA4T2gzsPILBZviXMCV+dgJOOKA92T4jK9SPl67VJ5t697z7TGQMFTFUA9dKzY6RHbuIzRUjtHYsXFXRb3zp9fmjbd3I32soGemJK7bOAojLtCFLuM61ivrS1Pezh5RjpbQDdfMyxvDDa7xvb8VYP1KIGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989436; c=relaxed/simple;
	bh=isG9jsPKHnKCTQMHxlTaOoicLb3GzUpGmPfMpwWKHOM=;
	h=Date:To:From:Subject:Message-Id; b=JyXq2X1hRKoh62S4ukNAtiRW1o6IgPiQiQQhV8h7ubjq+sodVXe6qo23oV1/rwY0h5UuSuCv4wniH1wKjMQGYrPKe/bo3qRNJFcf9jpKhwVIFk0sPEaQdIr++Gcvna0UTDrR+iAjgFfd+XL5jalErL4MEnzhVuJY7PkTBzwy/us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MPoKWZz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MPoKWZz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939F7C2BBFC;
	Fri, 21 Jun 2024 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718989435;
	bh=isG9jsPKHnKCTQMHxlTaOoicLb3GzUpGmPfMpwWKHOM=;
	h=Date:To:From:Subject:From;
	b=MPoKWZz4HZU3Qt0CZXKhKjQkA8oZMwGP7YKyqq8mmrCu+EI5w1TOzxxml7NK60BU7
	 lnr83rVhRUX81OrL2gcLNjtz+xSxyyKhudIonUf5Zv8nltCqs8yQQlZ355mqcmQxBb
	 pWkWXngB3/q+/p0suitnzYHK6bnDTDtBAgkR4Xb8=
Date: Fri, 21 Jun 2024 10:03:55 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch added to mm-unstable branch
Message-Id: <20240621170355.939F7C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: document DAMON community meetups
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

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
Subject: Docs/mm/damon/maintainer-profile: document DAMON community meetups
Date: Fri, 21 Jun 2024 09:36:26 -0700

DAMON bi-weekly community meetup series has continued since 2022-08-15 for
community members who prefer synchronous chat over asynchronous mails. 
Recently I got some feedbacks about the series from a few people.  They
told me the series is helpful for understanding of the project and
particiapting to the development, but it could be further better in terms
of the visibility.  Based on that, I started sending meeting reminder for
every occurrence.  For people who don't subscribe the mailing list,
however, adding an announcement on the official document could be helpful.
Document the series on DAMON maintainer's profile for the purpose.

Link: https://lkml.kernel.org/r/20240621163626.74815-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |   19 ++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-document-damon-community-meetups
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -69,6 +69,24 @@ In other words, ``hkml`` [8]_ is a maili
 DAMON maintainer is committed to support.  Please feel free to try and report
 issues or feature requests for the tool to the maintainer.
 
+Community meetup
+----------------
+
+DAMON community is maintaining two bi-weekly meetup series for community
+members who prefer synchronous conversations over mails.
+
+The first one is for any discussion between every community member.  No
+reservation is needed.
+
+The seconds one is for discussions on specific topics between restricted
+members including the maintainer.  The maintainer shares the available time
+slots, and attendees should reserve one of those at least 24 hours before the
+time slot, by reaching out to the maintainer.
+
+Schedules and available reservation time slots are available at the Google doc
+[9]_ .  DAMON maintainer will also provide periodic reminder to the mailing
+list (damon@lists.linux.dev).
+
 
 .. [1] https://git.kernel.org/akpm/mm/h/mm-unstable
 .. [2] https://git.kernel.org/sj/h/damon/next
@@ -78,3 +96,4 @@ issues or feature requests for the tool
 .. [6] https://github.com/awslabs/damon-tests/tree/master/corr
 .. [7] https://github.com/awslabs/damon-tests/tree/master/perf
 .. [8] https://github.com/damonitor/hackermail
+.. [9] https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix.patch
docs-damon-document-damos_migrate_hotcold-fix.patch
mm-damon-core-implement-damos-quota-goals-online-commit-function.patch
mm-damon-core-implement-damon-context-commit-function.patch
mm-damon-sysfs-use-damon_commit_ctx.patch
mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch
mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch
mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch
mm-damon-reclaim-use-damon_commit_ctx.patch
mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch
mm-damon-lru_sort-use-damon_commit_ctx.patch
mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

