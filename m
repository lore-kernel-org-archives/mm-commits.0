Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A92F22332A
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 05:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003801; cv=none; b=n6nrVqAtTyic/198dr8ZNfRtaD/goDxMzAYarz0xHjMjj635uKsol7Dygx9xDE140uRlzWjzxuUsSLh0D/WvDrzCbtTTnzaK426oIFnSgRq9T4Ak2TfhLjuH4tFSXVlDb/Km09tc2+yDKZCMWL7nPypcS9311z8uuGtSOCPYock=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003801; c=relaxed/simple;
	bh=YP9Sm2bpoxFaEYRmnN7BHC2xPn1y+dMm/Ix6sUUNZ78=;
	h=Date:To:From:Subject:Message-Id; b=h+/R+5RaJxYLb7flquFcKZiepHiede/p4e3oCgDZUz3XUuJbk5NqVNnU+Hu3N2FPn8UChK5RTmWct/4XXPHM75Iz15ZXtji+Fk0gaBkw2RBMJAxH3nEqLF6F9qIZ5zQrBUWZL6oHm1O2cdGVszCwKFErCktFzVSVmmj7nereABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1Z7NnurI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1Z7NnurI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF187C4CEDD;
	Mon,  7 Apr 2025 05:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744003800;
	bh=YP9Sm2bpoxFaEYRmnN7BHC2xPn1y+dMm/Ix6sUUNZ78=;
	h=Date:To:From:Subject:From;
	b=1Z7NnurIqW5rvxUioFLlSguQLsQB27bybPmY7Xlev+GD0sUoADELuu81VbiaNzE5W
	 26QfWAA9oQhZsPonfXWonx4R1YyeySvSibc9SClE8u4EIVoKy7iK2gdF8kW1tM31+A
	 lyTddKCQdmGXqz2ihPESz5l/RbMrY6tgaCdYJZiQ=
Date: Sun, 06 Apr 2025 22:30:00 -0700
To: mm-commits@vger.kernel.org,mario.limonciello@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kstrtox-add-support-for-enabled-and-disabled-in-kstrtobool.patch added to mm-nonmm-unstable branch
Message-Id: <20250407053000.AF187C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kstrtox: add support for enabled and disabled in kstrtobool()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kstrtox-add-support-for-enabled-and-disabled-in-kstrtobool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kstrtox-add-support-for-enabled-and-disabled-in-kstrtobool.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Mario Limonciello <mario.limonciello@amd.com>
Subject: kstrtox: add support for enabled and disabled in kstrtobool()
Date: Thu, 20 Mar 2025 21:25:01 -0500

In some places in the kernel there is a design pattern for sysfs
attributes to use kstrtobool() in store() and str_enabled_disabled() in
show().

This is counterintuitive to interact with because kstrtobool() takes
on/off but str_enabled_disabled() shows enabled/disabled.  Some of those
sysfs uses could switch to str_on_off() but for some attributes
enabled/disabled really makes more sense.

Add support for kstrtobool() to accept enabled/disabled.

Link: https://lkml.kernel.org/r/20250321022538.1532445-1-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/kstrtox.c~kstrtox-add-support-for-enabled-and-disabled-in-kstrtobool
+++ a/lib/kstrtox.c
@@ -351,6 +351,8 @@ int kstrtobool(const char *s, bool *res)
 		return -EINVAL;
 
 	switch (s[0]) {
+	case 'e':
+	case 'E':
 	case 'y':
 	case 'Y':
 	case 't':
@@ -358,6 +360,8 @@ int kstrtobool(const char *s, bool *res)
 	case '1':
 		*res = true;
 		return 0;
+	case 'd':
+	case 'D':
 	case 'n':
 	case 'N':
 	case 'f':
_

Patches currently in -mm which might be from mario.limonciello@amd.com are

kstrtox-add-support-for-enabled-and-disabled-in-kstrtobool.patch

