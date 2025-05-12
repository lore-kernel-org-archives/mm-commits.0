Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6B01A239D
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011346; cv=none; b=D4TG1mjSoAjmtuuxG1HL+6V0nfVdtftAt+myeCPCTVgzLMbKr7PKEKfnOEuqQJETf9BGtrbLEcAKEf9NuWEyUA6sLccDvUlMoZYAq4tIOOgYoIiY+oGSY+QjCzWZ9NWZfmESAuuwxgRwrcegNIqP76iyYfCyoWokww9ABOEB9eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011346; c=relaxed/simple;
	bh=x7ihVcFTcZe8oYxH2gruc0N/QBRPrtfiKtf8gHk57gM=;
	h=Date:To:From:Subject:Message-Id; b=n0R3s11gRPVn86YdVbzx7/dqtykluWst7eZbdsLRXnRZN9pibOuRG3oJRVXVsIKyHyzVuKJHYbeCdsPLh1VOr4PR3aiV1gCZlRGDzOpqzL3eTh7ssgnQsTAJ5s2Rm0V8g3ueCi3JUCogk4R78yFFxNo1/jiwyA7+VzWHjFdKSVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q5Nn4o4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q5Nn4o4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC258C4CEE4;
	Mon, 12 May 2025 00:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011345;
	bh=x7ihVcFTcZe8oYxH2gruc0N/QBRPrtfiKtf8gHk57gM=;
	h=Date:To:From:Subject:From;
	b=Q5Nn4o4R2yW1iRj7SFDpRHniUc8GarHj8mWsKHOIGM+Yaf1lSOqPq3cqatpVc00oI
	 jgn7m+nzcFqrhIZK1y+wxfVwSZTzfNEjLuVcuYKYSKNGSIld5q/tnpM6u5KnCH8qLV
	 ZwbCy34lyeFQtTuVD3Aci8yhWLtG9+/NcwJDyTqc=
Date: Sun, 11 May 2025 17:55:45 -0700
To: mm-commits@vger.kernel.org,viresh.kumar@linaro.org,rafael@kernel.org,lukas.bulwahn@gmail.com,louis.chauvet@bootlin.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,jim.cromie@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-dont-warn-about-unused-macro-arg-on-empty-body.patch removed from -mm tree
Message-Id: <20250512005545.BC258C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: dont warn about unused macro arg on empty body
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-warn-about-unused-macro-arg-on-empty-body.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jim Cromie <jim.cromie@gmail.com>
Subject: checkpatch: dont warn about unused macro arg on empty body
Date: Tue, 25 Mar 2025 17:51:54 -0600

Patch series "2 checkpatch fixes, one pr_info_once".

2 small tweaks to checkpatch,
1 reducing several pages of powernow "not-relevant-here" log-msgs to a few lines


This patch (of 3):

We currently get:
  WARNING: Argument 'name' is not used in function-like macro
on:
  #define DRM_CLASSMAP_USE(name)  /* nothing here */

Following this advice is wrong here, and shouldn't be fixed by ignoring
args altogether; the macro should properly fail if invoked with 0 or 2+
args.

Link: https://lkml.kernel.org/r/20250325235156.663269-1-jim.cromie@gmail.com
Link: https://lkml.kernel.org/r/20250325235156.663269-2-jim.cromie@gmail.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Reviewed-by: Louis Chauvet <louis.chauvet@bootlin.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:"Rafael J. Wysocki" <rafael@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-dont-warn-about-unused-macro-arg-on-empty-body
+++ a/scripts/checkpatch.pl
@@ -6024,7 +6024,7 @@ sub process {
 				}
 
 # check if this is an unused argument
-				if ($define_stmt !~ /\b$arg\b/) {
+				if ($define_stmt !~ /\b$arg\b/ && $define_stmt) {
 					WARN("MACRO_ARG_UNUSED",
 					     "Argument '$arg' is not used in function-like macro\n" . "$herectx");
 				}
_

Patches currently in -mm which might be from jim.cromie@gmail.com are


