Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794623805;
	b=PjgVHd6k98dwfShPaZNCvwYWNqjdqku9W9J1GejusyJ+vl1JJXuI4/dbazdoQQ24zqRj
	 jQ4ldh9aAcrP7v+NoQ4y0qkSkRUBJb7lG8lFv6C/RkhZ90GPnUeBheWR1seOvSZR3R+GH
	 xP9KsngzfuWG5iVyxGU5fRsHDee/Hk7MgRum+PFtJ5zMpuFvok9TlzO0WoqbhWXv4sCvj
	 9Io6hZ3YihXvkGoUz0g5VX3wgtijADCnCqI+61MFba+6zTMdDetiQNoFIXvfw0G5FCN4s
	 /vodPbUMNvfiFHKXuh/ebWLf3Qh7qbGTqUVJ4mH/RQKiIY0j8zOA1lpZ7IIlpRfN/zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794623805;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=QC9W2ITvyuDwH5W3a2sU0R4+fxr6DJiMRIBvFK+4qW4=;
	b=3xcQYmODYqwLcjeTDbog8RE8W3Ib0T4QsqSgiLDPkjWAOBRFRcfpiTyjtccChF0xf/rs
	 MwIW7myv4S+ggZ5rIk6Zu7TIp1b7LK5noQ+OAQGZMZR8tIooHU2HNVUYY5HRtNYcRSQPy
	 ZZ2dskZIABex+kMwQh+IXCD53vUJHqawvh9DaKkO9I82Tcexze6UCTdNSCrx3UMX2jLMQ
	 V7Rk1dxpJJFKyvhp2Gn2kaUJ8LKSHL5AoezgaWOMYYajP4+kqXluFPl+5QZew7yyYb7GB
	 gOEWgV8dX03K38qObrMhcFhTYQjmGTewUTghNV4Jtk/h9QeSXDD5fj/vQcAKwsEG3Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eCpPElYt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D837606A323
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 02:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eCpPElYt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41C11F000C4;
	Sat, 14 Nov 2026 02:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794623805;
	bh=QC9W2ITvyuDwH5W3a2sU0R4+fxr6DJiMRIBvFK+4qW4=;
	h=Date:To:From:Subject;
	b=eCpPElYtYfxPTu9YXRs7JkfcRWEMvrfr0YmU01zNbdaqvV9kqYc2wXJCEUHwz1ajD
	 29bDkpPjEPOFNdyKpJ7RcVoj0vph2in3fUj54PqlUfvS3ZflEr5aD5Sp8TSGHPEt9o
	 FvCMOEFrJmUUK2O/mnDFGrdjQTVAruNFApdwKofw=
Date: Fri, 13 Nov 2026 18:36:44 -0800
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,
	feng.tang@linux.alibaba.com,leon.hwang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sys_info-avoid-showing-locks-info-twice-in-__sys_info.patch added to mm-nonmm-unstable branch
Message-Id: <20261114023644.E41C11F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/sys_info: avoid showing locks info twice in __sys_info
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sys_info-avoid-showing-locks-info-twice-in-__sys_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sys_info-avoid-showing-locks-info-twice-in-__sys_info.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Leon Hwang <leon.hwang@linux.dev>
Subject: lib/sys_info: avoid showing locks info twice in __sys_info
Date: Fri, 13 Nov 2026 23:14:51 +0800

In __sys_info(), if the si_mask has both SYS_INFO_TASKS and
SYS_INFO_LOCKS, the locks info will be printed twice:
debug_show_all_locks() is also called inner show_state().

Since commit
8b2b9b4f6f4f ("hung_task: add hung_task_sys_info sysctl to dump sys info on task-hung"),
hung_task will print locks info twice when
sysctl -w kernel.hung_task_sys_info="tasks,locks".

[ 4658.894440]
               Showing all locks held in the system:
[ 4658.894445] locks held by khungtaskd/119: 1, last CPU#7:
[ 4658.894449]  #0: ffffffff9159cd00 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x3b/0x1f0
[ 4658.894468] locks held by cat/674: 1, on CPU#8:
[ 4658.894472]  #0: ffffffffc01681a0 (dummy_mutex){+.+.}-{4:4}, at: read_dummy_mutex+0x34/0x80 [hung_task_tests]
[ 4658.894487] locks held by cat/676: 1, on CPU#8:
[ 4658.894490]  #0: ffffffffc01681a0 (dummy_mutex){+.+.}-{4:4}, at: read_dummy_mutex+0x34/0x80 [hung_task_tests]
[ 4658.894504] locks held by dmesg/677: 5, last CPU#8:
[ 4658.894507]  #0: ff426e3f828ee0a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x34/0x40
[ 4658.894521]  #1: ff426e3f828ee128 (&tty->atomic_write_lock){+.+.}-{4:4}, at: file_tty_write.isra.0+0xaa/0x360
[ 4658.894535]  #2: ff426e3f828ee2c8 (&tty->termios_rwsem){++++}-{4:4}, at: n_tty_write+0x9d/0x4c0
[ 4658.894549]  #3: ff4fe07e82c57370 (&ldata->output_lock){+.+.}-{4:4}, at: remove_wait_queue+0x1b/0x60
[ 4658.894563]  #4: ffffffff927b1278 (&port_lock_key){-.-.}-{3:3}, at: uart_write_room+0x4e/0x230

[ 4658.894581] =============================================

[ 4658.894583]
               Showing all locks held in the system:
[ 4658.894586] locks held by khungtaskd/119: 1, last CPU#7:
[ 4658.894589]  #0: ffffffff9159cd00 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x3b/0x1f0
[ 4658.894604] locks held by cat/674: 1, on CPU#8:
[ 4658.894607]  #0: ffffffffc01681a0 (dummy_mutex){+.+.}-{4:4}, at: read_dummy_mutex+0x34/0x80 [hung_task_tests]
[ 4658.894622] locks held by cat/676: 1, on CPU#8:
[ 4658.894625]  #0: ffffffffc01681a0 (dummy_mutex){+.+.}-{4:4}, at: read_dummy_mutex+0x34/0x80 [hung_task_tests]
[ 4658.894639] locks held by dmesg/677: 5, last CPU#8:
[ 4658.894642]  #0: ff426e3f828ee0a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x34/0x40
[ 4658.894655]  #1: ff426e3f828ee128 (&tty->atomic_write_lock){+.+.}-{4:4}, at: file_tty_write.isra.0+0xaa/0x360
[ 4658.894669]  #2: ff426e3f828ee2c8 (&tty->termios_rwsem){++++}-{4:4}, at: n_tty_write+0x9d/0x4c0
[ 4658.894683]  #3: ff4fe07e82c57370 (&ldata->output_lock){+.+.}-{4:4}, at: n_tty_write+0x190/0x4c0
[ 4658.894697]  #4: ffffffff927b1278 (&port_lock_key){-.-.}-{3:3}, at: uart_write_room+0x4e/0x230

[ 4658.894713] =============================================

To avoid showing locks info again, check '!(si_mask & SYS_INFO_TASKS)'
when checking 'si_mask & SYS_INFO_LOCKS' in __sys_info().

Link: https://lore.kernel.org/20261113151451.72419-1-leon.hwang@linux.dev
Fixes: 8b2b9b4f6f4f ("hung_task: add hung_task_sys_info sysctl to dump sys info on task-hung")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Feng Tang <feng.tang@linux.alibaba.com>

 lib/sys_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/sys_info.c~lib-sys_info-avoid-showing-locks-info-twice-in-__sys_info
+++ a/lib/sys_info.c
@@ -147,7 +147,7 @@ static void __sys_info(unsigned long si_
 	if (si_mask & SYS_INFO_TIMERS)
 		sysrq_timer_list_show();
 
-	if (si_mask & SYS_INFO_LOCKS)
+	if ((si_mask & SYS_INFO_LOCKS) && !(si_mask & SYS_INFO_TASKS))
 		debug_show_all_locks();
 
 	if (si_mask & SYS_INFO_FTRACE)
_

Patches currently in -mm which might be from leon.hwang@linux.dev are

lib-sys_info-avoid-showing-locks-info-twice-in-__sys_info.patch

