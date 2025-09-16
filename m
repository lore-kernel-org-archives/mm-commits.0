Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6428F13C9C4
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757996336; cv=none; b=M7q43ClUr1N9q1i1J0gE3F5WMHp27eQP0TF3oeFa9AM0vWAuwVxl4KX60rqZQyqNq/OKGuRyD53vaUcG1YJ44wSvekmEQq7X61g6Pz3ozqLWaIuaz0rBAR1AzkmGZzUkUh1c8Q0L/Br2YuOQRh3jBbKVwyv9uuYrvSslzX5C2N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757996336; c=relaxed/simple;
	bh=cME56v1sudDAuAj5mcmpMsiPv6EfdUrxTmtFhNw8se8=;
	h=Date:To:From:Subject:Message-Id; b=jDCWo2IiejLb81dYQMZYOJihpq4iUaeEVWaLE26lA35KWjBJ+RBtNMWzn7CH38K+x1+jLtMATlHrplsMxokFP9ICxB1jJKw3KtYEpsyyvqizUtV6vWcFcfpawRxG4QhvFolH4+wleccQ3dxdvw3wduZvQw9VbWoILyTpNOWK/Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nppRrKRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nppRrKRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31C0C4CEEB;
	Tue, 16 Sep 2025 04:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757996335;
	bh=cME56v1sudDAuAj5mcmpMsiPv6EfdUrxTmtFhNw8se8=;
	h=Date:To:From:Subject:From;
	b=nppRrKRNCwo6UzG6oLWcfvVXz61iwzaK2+6Ats5GP/gkpQqJoDCime5WQT7lCNuRs
	 OJUUQVzFgPsbF859LlJElQpP4E/ok4udr7VYPijdQoGDxQsEMpRNBO0XxbLFjXmnTi
	 ZyYQLmmVSUnQr+Pbs0kNuEt/pf+rHLYw9pChvxY8=
Date: Mon, 15 Sep 2025 21:18:55 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch added to mm-new branch
Message-Id: <20250916041855.D31C0C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example command
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example command
Date: Mon, 15 Sep 2025 20:23:38 -0700

The example command doesn't work [1] on the latest DAMON user-space tool,
since --damos_action option is updated to receive multiple arguments, and
hence cannot know if the final argument is for deductible monitoring
target or an argument for --damos_action option.  Add --target_pid option
to let damo understand it is for target pid.

Link: https://lkml.kernel.org/r/20250916032339.115817-5-sj@kernel.org
Link: https://github.com/damonitor/damo/pull/32 [2]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -175,4 +175,4 @@ Below command makes every memory region
 
     $ sudo damo start --damos_access_rate 0 0 --damos_sz_region 4K max \
                       --damos_age 60s max --damos_action pageout \
-                      <pid of your workload>
+                      --target_pid <pid of your workload>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch
mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch

