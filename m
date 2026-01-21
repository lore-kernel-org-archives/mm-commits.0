Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8E62FE591
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967350; cv=none; b=DlNtiHw1jd2IjQbkYihmHvK/SpgJoo22500av43Y6xQ4D1LHki58bNoj9KDk/3MjhnN4OG6CezK6GqxJS+f5c7A3ghkZ5dT7cQ2/PVLDmdOVGY6QJxshvezRfh4z0M2j3R0Lb/r/EsqpJYdUhHi9T2UYQAzuXvx/7+++SLBkr+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967350; c=relaxed/simple;
	bh=ANNCb0fNciO9DvABse/JTU4dthdxgbtIaLxKgO3sh6s=;
	h=Date:To:From:Subject:Message-Id; b=a4IiIjdXU18dUlvsOHtU8o/ALfPfvgkfji3p12mfIE59SOBCgagLSzu8M4EPZVTrJmHYoud+G0yk7MwJd/zBug3BjtCvYN1Ibs6W7Vdx/MDrDnzhZ1N+5qo//MB6QP0MNXNjObqRhnD1MeZY38L8MURQntUIUI+OvnW07tmtItw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EYgFIRmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EYgFIRmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84957C16AAE;
	Wed, 21 Jan 2026 03:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967349;
	bh=ANNCb0fNciO9DvABse/JTU4dthdxgbtIaLxKgO3sh6s=;
	h=Date:To:From:Subject:From;
	b=EYgFIRmG1kZfSuEaEjJecsnZ5sckJ+IYYeIcYwmbWu8C4kdPaZRB3quix5/onE3Ef
	 oxq3aFa6jNTKwp91LHllc9JVoIzAHuum4WSMy582LvmTUtV8p6mMXYZOgYUBejRG1S
	 UToVrxlYaPppBACI4fLzXbKj6Cy+DEjgdGuGQGrE=
Date: Tue, 20 Jan 2026 19:49:09 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kallsyms-prevent-module-removal-when-printing-module-name-and-buildid.patch removed from -mm tree
Message-Id: <20260121034909.84957C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kallsyms: prevent module removal when printing module name and buildid
has been removed from the -mm tree.  Its filename was
     kallsyms-prevent-module-removal-when-printing-module-name-and-buildid.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kallsyms: prevent module removal when printing module name and buildid
Date: Fri, 28 Nov 2025 14:59:20 +0100

kallsyms_lookup_buildid() copies the symbol name into the given buffer so
that it can be safely read anytime later.  But it just copies pointers to
mod->name and mod->build_id which might get reused after the related
struct module gets removed.

The lifetime of struct module is synchronized using RCU.  Take the rcu
read lock for the entire __sprint_symbol().

Link: https://lkml.kernel.org/r/20251128135920.217303-8-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kallsyms.c~kallsyms-prevent-module-removal-when-printing-module-name-and-buildid
+++ a/kernel/kallsyms.c
@@ -474,6 +474,9 @@ static int __sprint_symbol(char *buffer,
 	unsigned long offset, size;
 	int len;
 
+	/* Prevent module removal until modname and modbuildid are printed */
+	guard(rcu)();
+
 	address += symbol_offset;
 	len = kallsyms_lookup_buildid(address, &size, &offset, &modname, &buildid,
 				       buffer);
_

Patches currently in -mm which might be from pmladek@suse.com are


