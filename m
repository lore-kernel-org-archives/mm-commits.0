Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D2B17555
	for <mm-commits@vger.kernel.org>; Sun, 11 May 2025 04:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746938315; cv=none; b=POliUz98wu7IEsV2qzWFjBsRzMTGagWkRag7l4aNZhw15XCt780xuG4AHCfTdYOPNmkN3BsPpdGPQWjBqhOyLjvGlDogaf2v5K5Wlp0tf+8omwdKJOMHCVglVoJvF0UdEDbEh/XtjUlh64EkwX5+diI6P4mGkWYv1OSYATKynjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746938315; c=relaxed/simple;
	bh=3dTJFiawwlFWmfu0dW3vSbdBq4Qlxhiz7OdSJVz6N1s=;
	h=Date:To:From:Subject:Message-Id; b=RtN6ePq5lLRjLGEcMkFA5LdxApL5fSOWVJNgv1k8xadl/QYIIuryxi8sXyVHiTyFx0vQw5c0WwGn7OYAPxj6a4Snz2LNdO1SS9aCHCMvsK2HxjIIQpAnxS5Ik8YyPIwirEqLP38VkzB+MSmRsCjKHIu2eWwCSCmKyEB6Lsva//k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lo6I8C1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lo6I8C1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2898C4CEE4;
	Sun, 11 May 2025 04:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746938314;
	bh=3dTJFiawwlFWmfu0dW3vSbdBq4Qlxhiz7OdSJVz6N1s=;
	h=Date:To:From:Subject:From;
	b=lo6I8C1SG1enSwKHutbYtFTifdpT99j1aLLSLa36tOZatCKvJ0sQg4B4fCtS06mbm
	 OdmnVfhsFKcHbTQp2guvj+VvFv91xOknOT0cE8ZD69iOl2QRt+w0oFiyOvVMwAnYGh
	 WZGQQpmt5uHevsXLGcKsGMH6hYGZA8yUJzzpSavc=
Date: Sat, 10 May 2025 21:38:34 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,oleg@redhat.com,mingo@kernel.org,mhocko@kernel.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,glider@google.com,brauner@kernel.org,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] exit-move-and-extend-sched_process_exit-tracepoint-fix.patch removed from -mm tree
Message-Id: <20250511043834.D2898C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: exit: document sched_process_exit and sched_process_template relation
has been removed from the -mm tree.  Its filename was
     exit-move-and-extend-sched_process_exit-tracepoint-fix.patch

This patch was dropped because it was folded into exit-move-and-extend-sched_process_exit-tracepoint.patch

------------------------------------------------------
From: Andrii Nakryiko <andrii@kernel.org>
Subject: exit: document sched_process_exit and sched_process_template relation
Date: Thu, 3 Apr 2025 10:41:20 -0700

Add an explicit note pointing out that sched_process_exit tracepoint is,
conceptually, related to sched_process_template and should be kept in sync
(though, on the best effort basis).

Link: https://lkml.kernel.org/r/20250403174120.4087794-1-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/sched.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/trace/events/sched.h~exit-move-and-extend-sched_process_exit-tracepoint-fix
+++ a/include/trace/events/sched.h
@@ -326,7 +326,11 @@ DEFINE_EVENT(sched_process_template, sch
 	     TP_ARGS(p));
 
 /*
- * Tracepoint for a task exiting:
+ * Tracepoint for a task exiting.
+ * Note, it's a superset of sched_process_template and should be kept
+ * compatible as much as possible. sched_process_exits has an extra
+ * `group_dead` argument, so sched_process_template can't be used,
+ * unfortunately, just like sched_migrate_task above.
  */
 TRACE_EVENT(sched_process_exit,
 
_

Patches currently in -mm which might be from andrii@kernel.org are

exit-move-and-extend-sched_process_exit-tracepoint.patch

