Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47856168B1
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 03:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738122869; cv=none; b=lZgLl8kpeMwaFjBQ+rdxt5+wJGn7DyE3tvePgORrS4cpBI+By65j93ov9OeqY7pEljQcNb+wxZT1c0X//IkiSu2aPxaiqpEETFh+5NgnQn95F8gy5i1HWeDjqAFjGFfL810omsE9Zy3nss9PcaX7baeqHsAg5muqJOcZniSpj+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738122869; c=relaxed/simple;
	bh=MXiKnHuilMIKu+fTwvBL7R7wkJ3QgYa7eSkaXX/8bDY=;
	h=Date:To:From:Subject:Message-Id; b=Ta0f/xbizkprWF+JlP7eGDZXrb0rbNeEHT9NsMVMTxdyoJaCViSoKvhptEq6gAIwmWjgHJbqzm9b/NplcnycLZmn7qCHiDZHjgMY74DkqW1SJwXRy2Xj8mdyGaB6B6qiDC0N4Q9SRcpZlyvZX7fkBIva1k3fcDnelySI838cQBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lT+Qv0Xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lT+Qv0Xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C871C4CED3;
	Wed, 29 Jan 2025 03:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738122868;
	bh=MXiKnHuilMIKu+fTwvBL7R7wkJ3QgYa7eSkaXX/8bDY=;
	h=Date:To:From:Subject:From;
	b=lT+Qv0Xx7E8/y1v+NFM5oL8g7Dpc5Dc+N7vPfzYakaUCnfO4vyj9eGo4Q5pTE/5D3
	 IsLcPOkgyP3oZkUCGcRcSA/7lsoISw97UK8ljWYYu93NwXOJSmQxUZl3+8PIHTiacL
	 a71ErZrqAzxfgva3xl3nRkh0arNfo12QedN7zXeA=
Date: Tue, 28 Jan 2025 19:54:27 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,tytso@mit.edu,nhorman@tuxdriver.com,mcgrof@kernel.org,linf@wangsu.com,kees@kernel.org,jirislaby@kernel.org,j.granados@samsung.com,jack@suse.cz,gregkh@linuxfoundation.org,brauner@kernel.org,nicolas.bouchinet@ssi.gouv.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + coredump-fixes-core_pipe_limit-sysctl-proc_handler.patch added to mm-nonmm-unstable branch
Message-Id: <20250129035428.7C871C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: coredump: fix core_pipe_limit sysctl proc_handler
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     coredump-fixes-core_pipe_limit-sysctl-proc_handler.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/coredump-fixes-core_pipe_limit-sysctl-proc_handler.patch

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
From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Subject: coredump: fix core_pipe_limit sysctl proc_handler
Date: Wed, 15 Jan 2025 14:22:08 +0100

Patch series " Fixes multiple sysctl proc_handler usage error", v4.

While reading sysctl code I encountered two sysctl proc_handler parameters
common errors.

The first one is to declare .data as a different type thant the return of
the used .proc_handler, i.e.  using proch_dointvec, thats convert a char
string to signed integers, and storing the result in a .data that is
backed by an unsigned int.  User can then write "-1" string, which results
in a different value stored in the .data variable.  This can lead to type
conversion errors in branches and thus to potential security issues.

From a quick search using regex and only for proc_dointvec, this seems to
be a pretty common mistake.

The second one is to declare .extra1 or .extra2 values with a
.proc_handler that don't uses them.  i.e, declaring .extra1 or .extra2
using proc_dointvec in order to declare conversion bounds do not work as
do_proc_dointvec don't uses those variables if not explicitly asked.

This patchset corrects three sysctl declaration that are buggy as an
example and is not exhaustive.


This patch (of 2):

proc_dointvec converts a string to a vector of signed int, which is stored
in the unsigned int .data core_pipe_limit.  It was thus authorized to
write a negative value to core_pipe_limit sysctl which once stored in
core_pipe_limit, leads to the signed int dump_count check against
core_pipe_limit never be true.  The same can be achieved with
core_pipe_limit set to INT_MAX.

Any negative write or >= to INT_MAX in core_pipe_limit sysctl would
hypothetically allow a user to create very high load on the system by
running processes that produces a coredump in case the core_pattern sysctl
is configured to pipe core files to user space helper.  Memory or PID
exhaustion should happen before but it anyway breaks the core_pipe_limit
semantic.

This commit fixes this by changing core_pipe_limit sysctl's proc_handler
to proc_dointvec_minmax and bound checking between SYSCTL_ZERO and
SYSCTL_INT_MAX.

Link: https://lkml.kernel.org/r/20250115132211.25400-1-nicolas.bouchinet@clip-os.org
Link: https://lkml.kernel.org/r/20250115132211.25400-2-nicolas.bouchinet@clip-os.org
Fixes: a293980c2e26 ("exec: let do_coredump() limit the number of concurrent dumps to pipes")
Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Kees Cook <kees@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Lin Feng <linf@wangsu.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Neil Horman" <nhorman@tuxdriver.com>
Cc: Ted Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/coredump.c~coredump-fixes-core_pipe_limit-sysctl-proc_handler
+++ a/fs/coredump.c
@@ -1015,7 +1015,9 @@ static struct ctl_table coredump_sysctls
 		.data		= &core_pipe_limit,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{
 		.procname       = "core_file_note_size_limit",
_

Patches currently in -mm which might be from nicolas.bouchinet@ssi.gouv.fr are

coredump-fixes-core_pipe_limit-sysctl-proc_handler.patch
sysctl-fix-underflow-value-setting-risk-in-vm_table.patch

