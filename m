Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FFF25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742232; cv=none; b=VJo0MZTUecd1Y1oQjf/ljvnPUzkBPurMa5EsVor0GiLcnkSO6dCgkhtVPVqKB4uG3/pErjgQYvYlNDFpwJQdiwKW/zhqOS1FGYadnQ83B/3/4/nQo8txoayC0ipCdcarA2QBL/taVYjW1OCejxfPkzI0vmKTNpheNemlMmWAExg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742232; c=relaxed/simple;
	bh=9YpM9qQ6jFiAY4BKdbKLECccNl/d5JSpsILXFjTuKYU=;
	h=Date:To:From:Subject:Message-Id; b=H1vl7loDihcL4E0LuijP+8b7ghs9Hc+5c1fmqEpVHOe82k7e+AAWOZ1DLEjiR5uYTMmPQyaoqWnf3Y5gd2rT2wfSVidKZU9ihh9PI3y9wzSrQQfjUVti3Jo3j6JtWioDCZ9tU0SecwK7YSCcOUbNghhwQlJJdOEPrwdn85N8qio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zvtvgzTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zvtvgzTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607C7C4CED6;
	Mon, 13 Jan 2025 04:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742232;
	bh=9YpM9qQ6jFiAY4BKdbKLECccNl/d5JSpsILXFjTuKYU=;
	h=Date:To:From:Subject:From;
	b=zvtvgzTneTNtoYT49joS7ovJnwdDKvDfbgzA1VP/OF0M/J7OtFOQjQyknDOk44RtJ
	 j64NbgQevX2+fYdw8XKnAlmRR31ogr1r2jkxH7+ynpVzKbLWKMZfvCuBbqQ4UQt+jr
	 IiBCUMrs8lQmqH8cLjOepDTSuqqw6gRsFptUYK58=
Date: Sun, 12 Jan 2025 20:23:51 -0800
To: mm-commits@vger.kernel.org,sstabellini@kernel.org,roger.pau@citrix.com,michal.orzel@amd.com,julien@xen.org,jbeulich@suse.com,anthony.perard@vates.tech,andrew.cooper3@citrix.com,ariel.otilibili-anieli@eurecom.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-remove-dead-code.patch removed from -mm tree
Message-Id: <20250113042352.607C7C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/inflate.c: remove dead code
has been removed from the -mm tree.  Its filename was
     lib-remove-dead-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
Subject: lib/inflate.c: remove dead code
Date: Thu, 19 Dec 2024 10:21:12 +0100

This is a follow up from a discussion in Xen:

The if-statement tests that `res` is non-zero; meaning the case zero is
never reached.

Link: https://lore.kernel.org/all/7587b503-b2ca-4476-8dc9-e9683d4ca5f0@suse.com/
Link: https://lkml.kernel.org/r/20241219092615.644642-2-ariel.otilibili-anieli@eurecom.fr
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
Suggested-by: Jan Beulich <jbeulich@suse.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Anthony PERARD <anthony.perard@vates.tech>
Cc: Michal Orzel <michal.orzel@amd.com>
Cc: Julien Grall <julien@xen.org>
Cc: Roger Pau Monné <roger.pau@citrix.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/inflate.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/inflate.c~lib-remove-dead-code
+++ a/lib/inflate.c
@@ -1257,8 +1257,6 @@ static int INIT gunzip(void)
     /* Decompress */
     if ((res = inflate())) {
 	    switch (res) {
-	    case 0:
-		    break;
 	    case 1:
 		    error("invalid compressed format (err=1)");
 		    break;
_

Patches currently in -mm which might be from ariel.otilibili-anieli@eurecom.fr are


