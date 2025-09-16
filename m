Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DF4221FC8
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757996334; cv=none; b=HkX2Yu3fHzC8GMBYUYN7nhoBnp8vqx6ad41+5FJT57k0jMQCIDFHkCR0GYqFmRX7k/SDnXWQvT4pu2RZ8TcLy3w5bqWrGS6nFOKgaYmZOi7XkaH5uZSkn5YHgNlpXQphEBrCgjNKUa9hkuBDlyPIgKjsjEwh1hrSZoqir0lM1Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757996334; c=relaxed/simple;
	bh=BWjyql/hFC4lWq57dKe56/f6GpdbMmLVN0CH6SUCScY=;
	h=Date:To:From:Subject:Message-Id; b=C4jrXtSRYmp1BOCM0+kES3iqmOipZvYvkQf3V4ITCSf/OkDxXImUikuHKuc1OhKiaAp8R5PjZFNaA6OVwX7vZhWWL1PKSdogdfbCy+iVcbn+MSu8+zdbSy1LnB8KJZbbty7V8gkAnnTc9Vx03+ZgUU5VpqmSpWeD9nbGnET8za8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l9o03xXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l9o03xXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8613C4CEEB;
	Tue, 16 Sep 2025 04:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757996333;
	bh=BWjyql/hFC4lWq57dKe56/f6GpdbMmLVN0CH6SUCScY=;
	h=Date:To:From:Subject:From;
	b=l9o03xXK2RynoZUo5c2Tf52WVm+mgdz5DbCILarRm22Y9eFqJoDmmx3MNfloZf19O
	 4pO6/Yr58ny69mnsmQMxwg2/dpcLLLfCU0PfaXYBNbv++njY3WU3Ckb8RV1E8lebRV
	 fWoePPz5gV85uH4YTphfMeHf0GctYPQXJAXvAAw4=
Date: Mon, 15 Sep 2025 21:18:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch added to mm-new branch
Message-Id: <20250916041853.B8613C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: update community meetup for reservation requirements
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch

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
Subject: Docs/mm/damon/maintainer-profile: update community meetup for reservation requirements
Date: Mon, 15 Sep 2025 20:23:37 -0700

DAMON community meetup was having two different kinds of meetups:
reservation required ones and unrequired ones.  Now the reservation
unrequested one is gone, but the documentation on the maintainer-profile
is not updated.  Update.

Link: https://lkml.kernel.org/r/20250916032339.115817-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |   17 +++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -89,18 +89,13 @@ the maintainer.
 Community meetup
 ----------------
 
-DAMON community is maintaining two bi-weekly meetup series for community
-members who prefer synchronous conversations over mails.
+DAMON community has a bi-weekly meetup series for members who prefer
+synchronous conversations over mails.  It is for discussions on specific topics
+between a group of members including the maintainer.  The maintainer shares the
+available time slots, and attendees should reserve one of those at least 24
+hours before the time slot, by reaching out to the maintainer.
 
-The first one is for any discussion between every community member.  No
-reservation is needed.
-
-The seconds one is for discussions on specific topics between restricted
-members including the maintainer.  The maintainer shares the available time
-slots, and attendees should reserve one of those at least 24 hours before the
-time slot, by reaching out to the maintainer.
-
-Schedules and available reservation time slots are available at the Google `doc
+Schedules and reservation status are available at the Google `doc
 <https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing>`_.
 There is also a public Google `calendar
 <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch
mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch

