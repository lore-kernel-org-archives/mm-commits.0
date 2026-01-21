Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF28431B123
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967349; cv=none; b=au10vWzNqtvtwRXxKtHXcydDl8z7OC5GMbKF+pXnf50E4P0rPfzeqYrXHtqnwbDJvh0K8wcYl5BUEi95+O72061V57b0oLpJBkaDMpK7GX6qe+hPqikC+MTmQAquCzspePo2GdRZ9kmUtUUeoI44nTn9yVZ6U/pq3T9J3UPD09s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967349; c=relaxed/simple;
	bh=ItZfxMXZJOGWUZ7oZAppzOeH5mFoKyaq0qTfgAH8Bl8=;
	h=Date:To:From:Subject:Message-Id; b=U1zcgxl0B9trkOk2S9jDN6UMhXOtu4/YQ7y6MVw6l9JY3ZJJ0XrnYUq1u8hAxHZcAi2rJRvoRelegC5NYMKYwBfGCH+8U41qRO9m/E+++6qqNKxc6ku3aTGw6fMm3wSFesBlqCTdnD8TYo/HW+6TYlb+8o48qUrRIbAivneaELs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tS2b+l6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tS2b+l6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42099C16AAE;
	Wed, 21 Jan 2026 03:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967348;
	bh=ItZfxMXZJOGWUZ7oZAppzOeH5mFoKyaq0qTfgAH8Bl8=;
	h=Date:To:From:Subject:From;
	b=tS2b+l6Cr9SBt336qcXhzZSgjmIMjpByytdH02DW9/ojEoyR7wCPFylh0hVtu4hG4
	 YQGFtzmDMJy7G43LFXRAZivG5AsgTeBhc94jkVeYJT+nHPPS5SxX6eifNtILSGkYVO
	 KgImR2+DkjFjBpJ3YX1MyryqSWjiN7WVqJ1JRyZE=
Date: Tue, 20 Jan 2026 19:49:07 -0800
To: mm-commits@vger.kernel.org,samitolvanen@google.com,rostedt@goodmis.org,petr.pavlu@suse.com,mhiramat@kernel.org,mcgrof@kernel.org,mark.rutland@arm.com,kees@kernel.org,john.fastabend@gmail.com,daniel@iogearbox.net,da.gomez@samsung.com,atomlin@atomlin.com,ast@kernel.org,pmladek@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup.patch removed from -mm tree
Message-Id: <20260121034908.42099C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()
has been removed from the -mm tree.  Its filename was
     kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: kallsyms/ftrace: set module buildid in ftrace_mod_address_lookup()
Date: Fri, 28 Nov 2025 14:59:19 +0100

__sprint_symbol() might access an invalid pointer when
kallsyms_lookup_buildid() returns a symbol found by
ftrace_mod_address_lookup().

The ftrace lookup function must set both @modname and @modbuildid the same
way as module_address_lookup().

Link: https://lkml.kernel.org/r/20251128135920.217303-7-pmladek@suse.com
Fixes: 9294523e3768 ("module: add printk formats to add module build ID to stacktraces")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ftrace.h |    6 ++++--
 kernel/kallsyms.c      |    4 ++--
 kernel/trace/ftrace.c  |    5 ++++-
 3 files changed, 10 insertions(+), 5 deletions(-)

--- a/include/linux/ftrace.h~kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup
+++ a/include/linux/ftrace.h
@@ -87,11 +87,13 @@ struct ftrace_hash;
 	defined(CONFIG_DYNAMIC_FTRACE)
 int
 ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym);
+			  unsigned long *off, char **modname,
+			  const unsigned char **modbuildid, char *sym);
 #else
 static inline int
 ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
+			  unsigned long *off, char **modname,
+			  const unsigned char **modbuildid, char *sym)
 {
 	return 0;
 }
--- a/kernel/kallsyms.c~kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup
+++ a/kernel/kallsyms.c
@@ -389,8 +389,8 @@ static int kallsyms_lookup_buildid(unsig
 		ret = bpf_address_lookup(addr, symbolsize, offset, namebuf);
 
 	if (!ret)
-		ret = ftrace_mod_address_lookup(addr, symbolsize,
-						offset, modname, namebuf);
+		ret = ftrace_mod_address_lookup(addr, symbolsize, offset,
+						modname, modbuildid, namebuf);
 
 	return ret;
 }
--- a/kernel/trace/ftrace.c~kallsyms-ftrace-set-module-buildid-in-ftrace_mod_address_lookup
+++ a/kernel/trace/ftrace.c
@@ -7753,7 +7753,8 @@ ftrace_func_address_lookup(struct ftrace
 
 int
 ftrace_mod_address_lookup(unsigned long addr, unsigned long *size,
-		   unsigned long *off, char **modname, char *sym)
+			  unsigned long *off, char **modname,
+			  const unsigned char **modbuildid, char *sym)
 {
 	struct ftrace_mod_map *mod_map;
 	int ret = 0;
@@ -7765,6 +7766,8 @@ ftrace_mod_address_lookup(unsigned long
 		if (ret) {
 			if (modname)
 				*modname = mod_map->mod->name;
+			if (modbuildid)
+				*modbuildid = module_buildid(mod_map->mod);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from pmladek@suse.com are


