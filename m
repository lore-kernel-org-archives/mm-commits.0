Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249B81B59A
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 18:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476497; cv=none; b=VW+LF8/Ca8OakiorjmJ5pa4P9kOK/a0ZkM9LnShqekApEkpDhH7j6OT22VyKUqqXwDtJMOuDfTyrVUnip2V/2xydYSAtbDVxdylm3dgvWH461pe15sB8xjtuPfe3fniplNbOF2tS0axQjCea+OO7ZudsuXBOKzW+e5WYoyiWjGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476497; c=relaxed/simple;
	bh=hqAZ6yL0dzA7w/GeryT1JYXVN6TybXAzz+0dBt2RQYI=;
	h=Date:To:From:Subject:Message-Id; b=uxjSQG7BjQ34KcRzkX27lixN78RSluSyHddm/qhTTwE7vXRRFoZPy8HGdBv1dNCz5RU9VC1iNoful4NgmGYVOqRSAkfr2ZSbsQvGKY5MXtfwj7yGYgKFdss3cZGaXMXQuczhNNpCMh0FLn9Rtiv0Br/1pWY1Qqyozowr3qaw3Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JEn9hwrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JEn9hwrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0375C43394;
	Tue, 26 Mar 2024 18:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476496;
	bh=hqAZ6yL0dzA7w/GeryT1JYXVN6TybXAzz+0dBt2RQYI=;
	h=Date:To:From:Subject:From;
	b=JEn9hwrx1miM+9ec2oiGKFgwTxTnLy6PlnBZNBnEt8/E48zxDG1sWusreC0VxfbHl
	 m30g++Fyg9DYmmiUmqAwOYvtlrguuKwEG8/c6biRbk3SNI+hLU2YxYv9rDpb0FIrLZ
	 jLCYezzqhC4SXAW7aJy5q89IzeZlaOxQ/CSpxs2s=
Date: Tue, 26 Mar 2024 11:08:16 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,joey.gouly@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-restore-settings-from-only-parent-process.patch removed from -mm tree
Message-Id: <20240326180816.B0375C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: restore settings from only parent process
has been removed from the -mm tree.  Its filename was
     selftests-mm-restore-settings-from-only-parent-process.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests: mm: restore settings from only parent process
Date: Thu, 14 Mar 2024 14:40:45 +0500

The atexit() is called from parent process as well as forked processes. 
Hence the child restores the settings at exit while the parent is still
executing.  Fix this by checking pid of atexit() calling process and only
restore THP number from parent process.

Link: https://lkml.kernel.org/r/20240314094045.157149-1-usama.anjum@collabora.com
Fixes: c23ea61726d5 ("selftests/mm: protection_keys: save/restore nr_hugepages settings")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Joey Gouly <joey.gouly@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/protection_keys.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-restore-settings-from-only-parent-process
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -1745,9 +1745,12 @@ void pkey_setup_shadow(void)
 	shadow_pkey_reg = __read_pkey_reg();
 }
 
+pid_t parent_pid;
+
 void restore_settings_atexit(void)
 {
-	cat_into_file(buf, "/proc/sys/vm/nr_hugepages");
+	if (parent_pid == getpid())
+		cat_into_file(buf, "/proc/sys/vm/nr_hugepages");
 }
 
 void save_settings(void)
@@ -1773,6 +1776,7 @@ void save_settings(void)
 		exit(__LINE__);
 	}
 
+	parent_pid = getpid();
 	atexit(restore_settings_atexit);
 	close(fd);
 }
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


