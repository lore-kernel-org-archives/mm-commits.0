Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227F115689A
	for <mm-commits@vger.kernel.org>; Sat, 22 Mar 2025 05:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742620092; cv=none; b=kmTjdwky0Y4GOgNETlrDRi6JoEYbChm9bx0g4NVTEjUPf8jk5z17pdePNkxxQXzqxHVLrj/S3olhYnPxQbRPtGtmh8vTDbQ24dvPfWd6mhwcRNMMJGLNl90bHz8byCXOEl5do3Es/My/VxUvIcGRnS6hPDf28zK/N9nivY9AHQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742620092; c=relaxed/simple;
	bh=0XFZa57MiKffz9uwG87TG7k3n+vc3JlIChdXtfZ/fcQ=;
	h=Date:To:From:Subject:Message-Id; b=a8+A1FjPG4oOe2/Chm4OsWTCNDVqVWVPx6HryGJkUpA+dqmnUngZeEWUFz9VSZbK9xu3AomN0zHvRCYz3zrvv9Sxxyls7dQjt6F7+HLSOx7Y1LtfgIUe/m8kgbhd0i+bljRj7LXabwo6iQrWfQrKr0iNxzA1pxjyO2xIgiXLPfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X9sE4SvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X9sE4SvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7666C4CEDD;
	Sat, 22 Mar 2025 05:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742620091;
	bh=0XFZa57MiKffz9uwG87TG7k3n+vc3JlIChdXtfZ/fcQ=;
	h=Date:To:From:Subject:From;
	b=X9sE4SvLuXxJN9542IOtnsNNDPdun9dVf1L+UpQX+dcGQZWodnfgzOOp5SDJV1QMF
	 JaQN2jepDwfDmKGLOWpAe11YKJajZ0n7hnPMvs+NjxakYlgeSHjTvDdlnr0LR7DBu6
	 /Dc4iHXKlv99LPnzkR4BD81UbiGVBlxc+VyuYaEc=
Date: Fri, 21 Mar 2025 22:08:11 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,tfiga@chromium.org,senozhatsky@chromium.org,rostedt@goodmis.org,mingo@redhat.com,mhiramat@kernel.org,longman@redhat.com,leonylgao@tencent.com,kent.overstreet@linux.dev,joel.granados@kernel.org,ioworker0@gmail.com,boqun.feng@gmail.com,anna.schumaker@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch removed from -mm tree
Message-Id: <20250322050811.D7666C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix
has been removed from the -mm tree.  Its filename was
     hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix.patch

This patch was dropped because it was folded into hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix
Date: Thu Mar 13 03:28:05 PM PDT 2025

implement debug_show_blocker() in C rather than in CPP

Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <tfiga@chromium.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yongliang Gao <leonylgao@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/hung_task.c~hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex-fix
+++ a/kernel/hung_task.c
@@ -125,7 +125,9 @@ static void debug_show_blocker(struct ta
 	}
 }
 #else
-#define debug_show_blocker(t)	do {} while (0)
+static inline void debug_show_blocker(struct task_struct *task)
+{
+}
 #endif
 
 static void check_hung_task(struct task_struct *t, unsigned long timeout)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-myself-as-userfaultfd-reviewer-checkpatch-fixes.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch
hung_task-show-the-blocker-task-if-the-task-is-hung-on-mutex.patch
samples-add-hung_task-detector-mutex-blocking-sample-fix.patch

