Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E76A8248B
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757995276; cv=none; b=Ala/0mpeqkSpYG1gujnC/WP044HLWgOWl87l7gzVIqTKgFxZTpCXMMWqiM8L4k0JHqlWNDtntbyqMFlzo2GupN6NLGNa0GEc7Ec8mF+WYYqFAO3y6PZfRUbEGwzTdpoqGAjeR3qDp4+Kt2rQQQEK0+ycvPOG7EPMGFoFdkygqkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757995276; c=relaxed/simple;
	bh=q0K0+bBQRdstrlj5wN/T3Go+AicYLPq10c+Sht0DliE=;
	h=Date:To:From:Subject:Message-Id; b=I6+dIVReKzDUXhN9ABou4YyoJ3ZQxlfqK7ZMrqMDOoqVr8vmO+5WnxU9rKBSJDyYYBZzyKKm5QaNTFh3W8Evzb9uyJHX8VYQ7pUL1utFkswuuxazoJsoAeUvGqLeDHZhmATmBNnN7TcRD/zYhUXOFmLbCZcJ6LWNpp4Bl4vaX50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BFZcu0T2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BFZcu0T2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995CBC4CEEB;
	Tue, 16 Sep 2025 04:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757995273;
	bh=q0K0+bBQRdstrlj5wN/T3Go+AicYLPq10c+Sht0DliE=;
	h=Date:To:From:Subject:From;
	b=BFZcu0T28rWgQ27ppBK3pXzkK3jJ0ZiLbnf7Hte0ym5zzlBs0oZKd1Bo7z+OYuoNg
	 Uj1D0nWkDc7zXBZ6wVKthXl+9SOJqO0p8zRI5gmDSieAPfWXKPw2qQ1OCP2gXqSjSI
	 qOYlw+ojDmGJC3GK3qSKTWVLLgjgTnqh54357psE=
Date: Mon, 15 Sep 2025 21:01:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch added to mm-new branch
Message-Id: <20250916040113.995CBC4CEEB@smtp.kernel.org>
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
Date: Sun, 14 Sep 2025 18:58:06 -0700

The example command doesn't work [1] on the latest DAMON user-space tool,
since --damos_action option is updated to receive multiple arguments, and
hence cannot know if the final argument is for deductible monitoring
target or an argument for --damos_action option.  Add --target_pid option
to let damo understand it is for target pid.

Link: https://lkml.kernel.org/r/20250915015807.101505-6-sj@kernel.org
Link: https://github.com/damonitor/damo/pull/32 [1]
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

mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
mm-damon-lru_sort-use-param_ctx-correctly.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch

