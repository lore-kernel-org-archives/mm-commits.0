Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51042EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011351; cv=none; b=SUIng2q7YuZRiRv7Vl3jRhAjTe0VzrMFNuqIEn3BA3jYsQeu+gKQ2jBbk91P9APk3mXlZiWOMqv2qNOZjPQOSXsYHelkTuCqFkikZXrxw7Q8Qr1CBn+ohbtiR6iPdSGqaaWpE0nHNdQSm86PNEkb8h4oA8OHrm1IHPorQX4+cWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011351; c=relaxed/simple;
	bh=01HVFL1vtfhtts0M5qMqMekp1gdEejmMCheMLnL9rfA=;
	h=Date:To:From:Subject:Message-Id; b=JOoI5k6yETm4dbTa1xsea88IM5RdXJWvd03LvF9xWtpDM/TAX3kPfSudJqkOQMNu3L3TdzynJ8wTiRiG30rKWTEWPIJxSkZ2Hgnp4mn46cbll8Q8cwmpbJhPt5zDPLQs4sUpDNPowKgFCC6tHCiuKLbsjg9owPkLXK8Zf+P+oOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kQ+f0p9X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kQ+f0p9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79586C4CEE4;
	Mon, 12 May 2025 00:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011351;
	bh=01HVFL1vtfhtts0M5qMqMekp1gdEejmMCheMLnL9rfA=;
	h=Date:To:From:Subject:From;
	b=kQ+f0p9XkYSU38hn2kyNnXPCFu+9Qp+STGRasdXj0yi318Cpj2q8v/Ly8oy9CCY/f
	 DqiOfVCfliCJOuHiVXqfcc/QWfJoZ7hcjRg8O3yTjWnFmHDMBbuMK4w16j7rZBio0M
	 bPklZT/KlM06lD/XJezNO6AecQXlefRst9IE01aw=
Date: Sun, 11 May 2025 17:55:50 -0700
To: mm-commits@vger.kernel.org,mario.limonciello@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kstrtox-add-support-for-enabled-and-disabled-in-kstrtobool.patch removed from -mm tree
Message-Id: <20250512005551.79586C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kstrtox: add support for enabled and disabled in kstrtobool()
has been removed from the -mm tree.  Its filename was
     kstrtox-add-support-for-enabled-and-disabled-in-kstrtobool.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


