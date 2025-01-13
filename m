Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFFF25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742193; cv=none; b=Tj89X7wTsg5gZcRcUi9lr412wk/Opmiv+e+M9kjQJ2UVyz4aHsu3JlETqvs2U1Q7phCEl02qrIOqv1nPl8pGRgitYMjRGAQDW5NGpjQVAX4OGi5YjGzMEK5k1b1BgWpBwXJ6d5PBLZGk5tcvYu1IBbRgg7OSVg77VUu6IsBwQcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742193; c=relaxed/simple;
	bh=doXrguKT6evM9QYp+Vs1iC9ze75ZF/l8NkoA0zp3cYY=;
	h=Date:To:From:Subject:Message-Id; b=Kvk8aJbr7zK+XxBcYhQuNqyR3HfTFMMPJWea4yMxQSAYvwIQcflpljBVoOD5TZjcdZe0Qd1b/d0/AfUNFu5Q7jyY8Men/QXm9phIC9jGLFTuf7fQ/SDc3mbc3szs+SK1JVHo+q//sg0tYWZpcy7DBE/2UGUqy7ddjaylqRjXz7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CLlojd+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CLlojd+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11E9C4CED6;
	Mon, 13 Jan 2025 04:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742193;
	bh=doXrguKT6evM9QYp+Vs1iC9ze75ZF/l8NkoA0zp3cYY=;
	h=Date:To:From:Subject:From;
	b=CLlojd+Z37kE4SuTLOL1LarHNDIIwwRGpuc4X7G1xk1HBdLnjlZIiFJHiR1BuG9Yu
	 m94B3a85gh3AfUmtnKfn+dRHEnhGKF4hYQ5MRUzhxDoe5aOHuOLEaWdlK6jCpVCYsM
	 OyYmRvrei5M6Vy/L83ByYscK0A6gKn1Qnyx8sPJ4=
Date: Sun, 12 Jan 2025 20:23:13 -0800
To: mm-commits@vger.kernel.org,oleg@redhat.com,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_task_exe_file-check-pf_kthread-locklessly.patch removed from -mm tree
Message-Id: <20250113042313.A11E9C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get_task_exe_file: check PF_KTHREAD locklessly
has been removed from the -mm tree.  Its filename was
     get_task_exe_file-check-pf_kthread-locklessly.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: get_task_exe_file: check PF_KTHREAD locklessly
Date: Tue, 19 Nov 2024 15:35:26 +0100

Same thing as 8ac5dc66599c ("get_task_mm: check PF_KTHREAD lockless")

Nowadays PF_KTHREAD is sticky and it was never protected by ->alloc_lock. 
Move the PF_KTHREAD check outside of task_lock() section to make this code
more understandable.

Link: https://lkml.kernel.org/r/20241119143526.704986-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/fork.c~get_task_exe_file-check-pf_kthread-locklessly
+++ a/kernel/fork.c
@@ -1514,12 +1514,13 @@ struct file *get_task_exe_file(struct ta
 	struct file *exe_file = NULL;
 	struct mm_struct *mm;
 
+	if (task->flags & PF_KTHREAD)
+		return NULL;
+
 	task_lock(task);
 	mm = task->mm;
-	if (mm) {
-		if (!(task->flags & PF_KTHREAD))
-			exe_file = get_mm_exe_file(mm);
-	}
+	if (mm)
+		exe_file = get_mm_exe_file(mm);
 	task_unlock(task);
 	return exe_file;
 }
_

Patches currently in -mm which might be from mjguzik@gmail.com are


