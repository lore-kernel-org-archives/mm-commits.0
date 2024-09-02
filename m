Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D167A14B092
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248856; cv=none; b=Vuir0/R2GeZms+QqijmSKCkZQxn7ehk3kdnluHFtOI50+AxbjWBizoeufc/DzGfxl8gTlgjYC6pWMV9pDwXJny9/rtdrRpZOPohCoX4PBJnbybG6inqTpjTiVMBgQRDI9tML18ZejYNRMgpLqT80ucS62NxfA9ToXQVBJuaIWFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248856; c=relaxed/simple;
	bh=n6STb+yNElqS7c4NN0nR8QveQ7XRjCIvqnOI9uUs1T8=;
	h=Date:To:From:Subject:Message-Id; b=RyVas7zj2zEXwFM7W+nVx2Uvyo8+OJaHbuZ2wXMcU/ppNIMCejw9G+/nCnwexZYd++kMkmOsNqDDXeaM3MXGtpzNNSUtdPM9D/8Xp54LPjGIngrYGzS8fW0+AYIsYA4IlsqSAFOmQwH73Gcv3m/Vu25iAKv/6PV2dtXTsa6E4uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i5CxJHQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i5CxJHQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A6FC4CEC2;
	Mon,  2 Sep 2024 03:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248856;
	bh=n6STb+yNElqS7c4NN0nR8QveQ7XRjCIvqnOI9uUs1T8=;
	h=Date:To:From:Subject:From;
	b=i5CxJHQjUo5LMGwKPtQOJxDSMPqE/iWinc7wwTwJofM+/0f8nIYFwM16Yd2RJ0Fef
	 PIYbyjw7fyMfJao+A5p4MSAd3vhB5dpFZBaWyzyIPqPL6kTmpAgmDiFwV2uQqVi1B3
	 gEdAn20LNvtvHzkLW8EgIUyjpbsUzDxSYtTAkcuE=
Date: Sun, 01 Sep 2024 20:47:36 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-remove-sc_timer_task.patch removed from -mm tree
Message-Id: <20240902034736.A6A6FC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: remove sc_timer_task
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-sc_timer_task.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: remove sc_timer_task
Date: Tue, 27 Aug 2024 02:41:14 +0900

After commit f5d4e04634c9 ("nilfs2: fix use-after-free of timer for log
writer thread") is applied, nilfs_construct_timeout(), which is called by
a timer and wakes up the log writer thread, is never called after the log
writer thread has terminated.

As a result, the member variable "sc_timer_task" of the "nilfs_sc_info"
structure, which was added when timer_setup() was adopted to retain a
reference to the log writer thread's task even after it had terminated, is
no longer needed, as it should be; we can simply use "sc_task" instead,
which holds a reference to the log writer thread's task for its lifetime. 
So, eliminate "sc_timer_task" by this means.

Link: https://lkml.kernel.org/r/20240826174116.5008-7-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    3 +--
 fs/nilfs2/segment.h |    2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-remove-sc_timer_task
+++ a/fs/nilfs2/segment.c
@@ -2502,7 +2502,7 @@ static void nilfs_construction_timeout(s
 {
 	struct nilfs_sc_info *sci = from_timer(sci, t, sc_timer);
 
-	wake_up_process(sci->sc_timer_task);
+	wake_up_process(sci->sc_task);
 }
 
 static void
@@ -2640,7 +2640,6 @@ static int nilfs_segctor_thread(void *ar
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int timeout = 0;
 
-	sci->sc_timer_task = current;
 	timer_setup(&sci->sc_timer, nilfs_construction_timeout, 0);
 
 	/* start sync. */
--- a/fs/nilfs2/segment.h~nilfs2-remove-sc_timer_task
+++ a/fs/nilfs2/segment.h
@@ -115,7 +115,6 @@ struct nilfs_segsum_pointer {
  * @sc_lseg_stime: Start time of the latest logical segment
  * @sc_watermark: Watermark for the number of dirty buffers
  * @sc_timer: Timer for segctord
- * @sc_timer_task: Thread woken up by @sc_timer
  * @sc_task: current thread of segctord
  */
 struct nilfs_sc_info {
@@ -172,7 +171,6 @@ struct nilfs_sc_info {
 	unsigned long		sc_watermark;
 
 	struct timer_list	sc_timer;
-	struct task_struct     *sc_timer_task;
 	struct task_struct     *sc_task;
 };
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


