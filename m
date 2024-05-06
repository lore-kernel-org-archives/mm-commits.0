Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A783BBEC
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958113; cv=none; b=ILQ9pNsONjTxppWhzV22vtsx15VBLsh1OYfZ119vkOZoHlvUrW841gIjUUCPa2yhQhi93mSfju+gtW7D5MUZwg2l6x0RyGKzGL5pPS7UWMh5WVGOONHT+VwnQG5uHpCbx4V/zoEYCkJy4Fhn+D83r8ts9CFlBv15gUOGkbZfHMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958113; c=relaxed/simple;
	bh=ZdcWeDWeeRKXvOYI5JIU4vXkJXmna2vCZGXNVoMcxXE=;
	h=Date:To:From:Subject:Message-Id; b=F3pi1e8iyJZjSJlw2O1cR1ob0LgJ0GXIZJP+cpLebnnBNUiWkfSbcryAMME6NonFExM7moQvyIqNgUghWAd/+HwIyFNaBvxvUNnq+O/4rjVYp1z/GOv4DKagx6A/LKa6GbWWgEZptxK42vXEyuOyFVmqFQbO/W8xX7YKJoScuBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gbokPzGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gbokPzGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC76CC116B1;
	Mon,  6 May 2024 01:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958112;
	bh=ZdcWeDWeeRKXvOYI5JIU4vXkJXmna2vCZGXNVoMcxXE=;
	h=Date:To:From:Subject:From;
	b=gbokPzGjXUjrD/NfGDL+qowKUL5Bc5ohY9SnMptZhM5bXAmubA+aDGxzYCFlesuj8
	 GIa2LOa+0+UGkLy+Allh7xnKWdwu2vOXxnjHF7Jqd94wyw6D7fsormwuCuyQ3NsYUV
	 kF0fEgQ7RVNQVfFkgLcS3DmraM/HuibSI4T/kWu0=
Date: Sun, 05 May 2024 18:15:12 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,song@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] watchdog-handle-comma-separated-nmi_watchdog-command-line.patch removed from -mm tree
Message-Id: <20240506011512.BC76CC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: watchdog: handle comma separated nmi_watchdog command line
has been removed from the -mm tree.  Its filename was
     watchdog-handle-comma-separated-nmi_watchdog-command-line.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Liu <song@kernel.org>
Subject: watchdog: handle comma separated nmi_watchdog command line
Date: Mon, 29 Apr 2024 23:02:35 -0700

Per the document, the kernel can accept comma separated command line like
nmi_watchdog=nopanic,0.  However, the code doesn't really handle it.  Fix
the kernel to handle it properly.

Link: https://lkml.kernel.org/r/20240430060236.1878002-1-song@kernel.org
Signed-off-by: Song Liu <song@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/watchdog.c~watchdog-handle-comma-separated-nmi_watchdog-command-line
+++ a/kernel/watchdog.c
@@ -71,6 +71,7 @@ void __init hardlockup_detector_disable(
 
 static int __init hardlockup_panic_setup(char *str)
 {
+next:
 	if (!strncmp(str, "panic", 5))
 		hardlockup_panic = 1;
 	else if (!strncmp(str, "nopanic", 7))
@@ -79,6 +80,12 @@ static int __init hardlockup_panic_setup
 		watchdog_hardlockup_user_enabled = 0;
 	else if (!strncmp(str, "1", 1))
 		watchdog_hardlockup_user_enabled = 1;
+	while (*(str++)) {
+		if (*str == ',') {
+			str++;
+			goto next;
+		}
+	}
 	return 1;
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
_

Patches currently in -mm which might be from song@kernel.org are


