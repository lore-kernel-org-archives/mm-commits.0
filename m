Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1F5388E6D
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777039923; cv=none; b=LiqHtMas+7exSR25yFPGIh3epmYO9CGiVnySNJV3wQ7DBEzdEtG4X2LawR+u5bTnnVICEFdfALz7+ZrhEjlT7NrTysCYqpbjLnXTqi2rIbWvyeF9K3bUaDz8C5YrJNCHdM0Nh1/4B2eE9nW1aSZqSb00edglflvpXIVl3wH51fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777039923; c=relaxed/simple;
	bh=4RusBpE9tRO4JPq5E+2gtdsVvoD9LlXKgNdI55EJgGg=;
	h=Date:To:From:Subject:Message-Id; b=PBB0cuM2VGHk+MBWGVJEjY+d7sVV42J9Q196cAjn6K3RFqtW2nUmgcv8v3aFN5WXZm4zUMH8w+FvnQ0SFGM462wsglTiglNowrg1yIhWh2QMNxgSf/8isdJ84JpzbJwMYk+G7qTAtwM8dEds75CIRFi8Fzp4TChXXniMRCpWMX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjBb5ndQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjBb5ndQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCC7C19425;
	Fri, 24 Apr 2026 14:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777039922;
	bh=4RusBpE9tRO4JPq5E+2gtdsVvoD9LlXKgNdI55EJgGg=;
	h=Date:To:From:Subject:From;
	b=GjBb5ndQGizHkTbljI+eL02rnNihHGHC1ieZIcyd2l+oJtMOvK6DjomwaOyewTQfO
	 laa0Llzqt5Fv1o/VhuRH77u6pSoUjTrrHfv+2JH4S+229JSk3+VLRHOEGLCtkbZn0G
	 2VI+YLWYw1K5D+eSNdp+peWNp8mBA4q43X5ROCoc=
Date: Fri, 24 Apr 2026 07:12:02 -0700
To: mm-commits@vger.kernel.org,jstultz@google.com,adobriyan@gmail.com,me@cherr.cc,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] proc-fix-comm_write-return-value-when-truncated-or-error.patch removed from -mm tree
Message-Id: <20260424141202.CCCC7C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: fix comm_write return value when truncated or error
has been removed from the -mm tree.  Its filename was
     proc-fix-comm_write-return-value-when-truncated-or-error.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: "Shengzhuo Wei" <me@cherr.cc>
Subject: proc: fix comm_write return value when truncated or error
Date: Fri, 24 Apr 2026 04:06:21 +0800

When count exceeds TASK_COMM_LEN-1, comm_write() copies at most
TASK_COMM_LEN-1 bytes but returns the original count.  This violates
write(2) semantics, which require returning the number of bytes actually
written.

The count parameter is size_t and should not be repurposed to carry a
negative error code on the same_thread_group() failure path.

Introduce a local len for the truncated length and a separate ssize_t ret
for the return value.

Link: https://lore.kernel.org/20260424-fix_proc_write_return-v1-1-7a793c2aad32@cherr.cc
Fixes: 4614a696bd1c ("procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm")
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Cc: John Stultz <jstultz@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c~proc-fix-comm_write-return-value-when-truncated-or-error
+++ a/fs/proc/base.c
@@ -1727,8 +1727,10 @@ static ssize_t comm_write(struct file *f
 	struct task_struct *p;
 	char buffer[TASK_COMM_LEN] = {};
 	const size_t maxlen = sizeof(buffer) - 1;
+	size_t len = count > maxlen ? maxlen : count;
+	ssize_t ret;
 
-	if (copy_from_user(buffer, buf, count > maxlen ? maxlen : count))
+	if (copy_from_user(buffer, buf, len))
 		return -EFAULT;
 
 	p = get_proc_task(inode);
@@ -1738,13 +1740,14 @@ static ssize_t comm_write(struct file *f
 	if (same_thread_group(current, p)) {
 		set_task_comm(p, buffer);
 		proc_comm_connector(p);
+		ret = len;
+	} else {
+		ret = -EINVAL;
 	}
-	else
-		count = -EINVAL;
 
 	put_task_struct(p);
 
-	return count;
+	return ret;
 }
 
 static int comm_show(struct seq_file *m, void *v)
_

Patches currently in -mm which might be from me@cherr.cc are


