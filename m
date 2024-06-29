Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA80BA46
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628233; cv=none; b=AO7l/5Cwha1FpfkOKPffzkYdhViq7HTvoiTOZ44L5MXx7n62yQk+DES9tms07yELpogLbVNo8LzrIvx4mAgWuJ3uR4eg8WYsC2gJUHzMKCkA3P5cVb1rIyYZDk0xDeUg/Na+09q892xSNX85V5h/17lsZfPad7jAXqqBXKxZdbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628233; c=relaxed/simple;
	bh=ExObLqW+OMjPVIvDF6qQStB8Ae4TjcSsiJjYwOettmE=;
	h=Date:To:From:Subject:Message-Id; b=BQut9DEL16sDNOdDGYjXVzQq/kLlqjIAmq9SKKU4573FRlJKSnF22SdrpmJGYzkW/sOw34UfjUpmSYOik1St7u/sdJ+WcLEAv3rZIOq6mQH3/8n/Nhvce7s9bYmm3xz+aIsMk/Q6b09mC3m7yTzmt3XGe0U8O8jAV1GiRmkJZJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qqZRHVK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qqZRHVK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C832C116B1;
	Sat, 29 Jun 2024 02:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628233;
	bh=ExObLqW+OMjPVIvDF6qQStB8Ae4TjcSsiJjYwOettmE=;
	h=Date:To:From:Subject:From;
	b=qqZRHVK3czAg94dkm9Kw9o6yaQgX+S6s2gl6c1S78MMpo9tfE993BxY752Rs0wa8U
	 X6XcuI+1Cjr4LWtW0++xaBY7CMqbNZzdtKC5Tgyy9nYOdqaWiVKAKYqGWXvRJkDVmH
	 fS0lbwXBiEmy2/t1+qnMSYmvYDuRx3z4A7FMRotE=
Date: Fri, 28 Jun 2024 19:30:32 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch removed from -mm tree
Message-Id: <20240629023033.1C832C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: document DAMON community meetups
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

