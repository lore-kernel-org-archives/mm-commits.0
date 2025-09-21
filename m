Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE3227281D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490016; cv=none; b=CitO6X3bnr/ugU7MmPtXEoMgRaMNij1I9UxympNzA5mnHNmDIHWYytZMH0CSxuaTd0lta20rIhLyOsVMBhZb9c/yKo8YN1/PYjM3N1wgJmozHTBPcjItXPsNyXK9lj8FDLwibkPNalteNILeG0iIF83By7b05gQzJmj0rXtTk+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490016; c=relaxed/simple;
	bh=iaNyuK7uP7vC03++lGpBcerR2eo7n5+6QxioVrOWX/8=;
	h=Date:To:From:Subject:Message-Id; b=tSkptnsnP5Q8Y8e9dsTn9USrDgOZKJ2rP4YX3fXtwQKWUL3SupdWBPR2EU5pYCIX5Wpp/Pn3CJ8FC9484Dc9IXhJsYxHMdres/aF3fegvzyca406EzNekoMO2W0hOaf5/o7sYMipmDBxRVJQrIpp8j7WaSMdA4iup0TeIjh40/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UX6viW1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UX6viW1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A240BC4CEE7;
	Sun, 21 Sep 2025 21:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490016;
	bh=iaNyuK7uP7vC03++lGpBcerR2eo7n5+6QxioVrOWX/8=;
	h=Date:To:From:Subject:From;
	b=UX6viW1TH1gqsmzArRhadzkSdsI8jsbWCQEcQm/OoswwrapN85U/uAqvp8B2a31JL
	 kDHefcFfSvt7ZQ2TLQqPCjgzDUpESHiZ04Ltyc41fSvk4+CkPnJUM8dWOiC6854G7r
	 4jgS5xsPG0GI88XTT6aYJprcwENzxvBQ0Kn4nojs=
Date: Sun, 21 Sep 2025 14:26:56 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch removed from -mm tree
Message-Id: <20250921212656.A240BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: update community meetup for reservation requirements
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-sysfs-set-damon_ctx-min_sz_region-only-for-paddr-use-case.patch

