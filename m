Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB72C18A925
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925228; cv=none; b=IlQwhlDDTsPYPpfbu/YPFlBE7GS2LzvyygYTug95WdGPwbz1EiZdQgVMInBrbwctFsYD4ib2co6/Avd6jpZkaUfAmrVVwzpBoiDotfhTOgTv1pD3oCtH8WggmVf8G1C5aypvPfc3KBtJ+e2lwIKbPWW7F8ngfz56eKDqNomJoaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925228; c=relaxed/simple;
	bh=Q/F0s3uZ2J0kEsfwEgeCaJwJ3qHkMoIXnuuRs9W9BYY=;
	h=Date:To:From:Subject:Message-Id; b=tyikd7X27noE/t+uroFjxg41bmeloulZL84Yh6YhI6Ydn20wbLpCkEF6Sx9lgrP7OBsYz0MwFVKE/AZraUAi6Xm+lhk3q8GewbCmRoZCsGU10yJvQeH50HuruwFaMwArw04cjjLswYUBsu7emOFvrzGUxH7ofSAUPwLy41B2F+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BLD96aC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BLD96aC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B027AC4CEC5;
	Mon,  9 Sep 2024 23:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925228;
	bh=Q/F0s3uZ2J0kEsfwEgeCaJwJ3qHkMoIXnuuRs9W9BYY=;
	h=Date:To:From:Subject:From;
	b=BLD96aC8fY86Y6mNSsKmL4+HVE+NYe8G7TRRXoOdMz0qx+Pq2iaV6Pg8sXjCBmszy
	 Pfo+a8jT1uMRmaeAiRDlGKFFC6XQdIULBWsz2kK+950eTyP8QGTKVN3w9FbYS80C9W
	 FF4bU4xHZnEOm56UhkO2QZFHOz/YZ3nWfh0m3lng=
Date: Mon, 09 Sep 2024 16:40:28 -0700
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch removed from -mm tree
Message-Id: <20240909234028.B027AC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/damon/maintainer-profile: document Google calendar for bi-weekly meetups
has been removed from the -mm tree.  Its filename was
     docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/damon/maintainer-profile: document Google calendar for bi-weekly meetups
Date: Sun, 25 Aug 2024 18:57:41 -0700

We added a public Google calendar for easy sharing of DAMON bi-weekly
meetups[1].  Add it to the official document for a better visibility.

[1] https://lore.kernel.org/all/20240717235812.53087-1-sj@kernel.org/

Link: https://lkml.kernel.org/r/20240826015741.80707-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-damon-maintainer-profile-document-google-calendar-for-bi-weekly-meetups
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -99,5 +99,7 @@ time slot, by reaching out to the mainta
 
 Schedules and available reservation time slots are available at the Google `doc
 <https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing>`.
-DAMON maintainer will also provide periodic reminder to the mailing list
-(damon@lists.linux.dev).
+There is also a public Google `calendar
+<https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`
+that has the events.  Anyone can subscribe it.  DAMON maintainer will also
+provide periodic reminder to the mailing list (damon@lists.linux.dev).
_

Patches currently in -mm which might be from sj@kernel.org are


