Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63DA1B85DC
	for <mm-commits@vger.kernel.org>; Sat,  7 Sep 2024 03:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725679008; cv=none; b=F09u6N//ekaV3i3wozy5GEhlgWu3vDZMJzWIWIsroPfwCixxVSYLWLxDuf3lLKNfloPDM89fvQMkokcu3RGzRolqejPovblHP3dTPSa3xwcH7MvAkubf56E4AIvndH5thGKsDnPtAL1vGBaIfv6C+kRJXpDsSPSgDlmjkYtIGAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725679008; c=relaxed/simple;
	bh=M4WjYKDusLS+bIxVqtPExMXhW7pj+I3Db6ea8HeGoFQ=;
	h=Date:To:From:Subject:Message-Id; b=cC/Coz/eFUrsKqA7zNOtksIsCWIG6QOhuwPeEjqSTnxBRh5KtU2r4uncg8mdcL03nq8iVd44n8mZTMsfrV1KL2kGey3uO8ygoQ2rzdhiJiGi8WC83pa/1roy+ZNr6Im6iTRlWSopWZX74HHfetCQNtUBkfxBKysizTe74bRjY+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lkUorw5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lkUorw5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB15C4CEC2;
	Sat,  7 Sep 2024 03:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725679008;
	bh=M4WjYKDusLS+bIxVqtPExMXhW7pj+I3Db6ea8HeGoFQ=;
	h=Date:To:From:Subject:From;
	b=lkUorw5ySXTuzpP3AMoTqMYl9D5ce5g8LA7L2/P7JB5ZL8FxU9AgR3n1rrJvYtRMc
	 MxucktqI2pZHhNmxxoGw2ou94HtbIQ1gJoK7EwVkk7p+gTv3EBAxJHYgRpJgpCo6wj
	 R4RQiUL7AoSRgV5/+2YXjP7f1bUND0fx9Qzc1HMw=
Date: Fri, 06 Sep 2024 20:16:47 -0700
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,peterz@infradead.org,oleg@redhat.com,namhyung@kernel.org,mingo@redhat.com,mhiramat@kernel.org,mark.rutland@arm.com,kan.liang@linux.intel.com,jolsa@kernel.org,irogers@google.com,alexander.shishkin@linux.intel.com,adrian.hunter@intel.com,acme@kernel.org,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + uprobes-use-vm_special_mapping-close-functionality-fix.patch added to mm-unstable branch
Message-Id: <20240907031648.1AB15C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: uprobes: remove unneeded condition
has been added to the -mm mm-unstable branch.  Its filename is
     uprobes-use-vm_special_mapping-close-functionality-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/uprobes-use-vm_special_mapping-close-functionality-fix.patch

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
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: uprobes: remove unneeded condition
Date: Fri, 6 Sep 2024 15:18:25 +0500

The area cannot be NULL as we are getting it through container_of(). 
Hence there is no need to check its validity.  Remove the if condition and
return statement.

Link: https://lkml.kernel.org/r/20240906101825.177490-1-usama.anjum@collabora.com
Fixes: ("uprobes: use vm_special_mapping close() functionality")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/events/uprobes.c~uprobes-use-vm_special_mapping-close-functionality-fix
+++ a/kernel/events/uprobes.c
@@ -1493,9 +1493,6 @@ static void uprobe_clear_state(const str
 	delayed_uprobe_remove(NULL, vma->vm_mm);
 	mutex_unlock(&delayed_uprobe_lock);
 
-	if (!area)
-		return;
-
 	put_page(area->pages[0]);
 	kfree(area->bitmap);
 	kfree(area);
_

Patches currently in -mm which might be from usama.anjum@collabora.com are

uprobes-use-vm_special_mapping-close-functionality-fix.patch

