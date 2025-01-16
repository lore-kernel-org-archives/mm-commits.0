Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1711218892D
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006298; cv=none; b=N93zTSExFNIj65Pdk4bBrtJscHJu2YzNA3WAc0BDMZD1+McoJwUj5Ym7zAxWeIAVRW83vGwTxAWTM8d5yEkakVn878ALCdYLOxxlkiTBzZWqaqVStNbZQXJiZwF+OY8HGyo26ig+FgmWG2eaAK9BEIkgIhjwD3scKpcK08maIzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006298; c=relaxed/simple;
	bh=QheorW66Ni1CHDBZ7144PGRETCjK9izVtAoVmbXM2Xc=;
	h=Date:To:From:Subject:Message-Id; b=J/oajatVvczHlrvQrJJfrtQ5dN94BcYNuCGKEZ7NG6oyT8A56mLGvSYBlJqWiEh4KoFIFkTS3R9wEygnncbQx0gtkc3zOCi7MelIhtldF49Lnavnx06GEylgkUgGH+rKXFk8WWcR7rkejhIEjajfx12YmlFxyyXMQ1WwkOMNeK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H1N1VphR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H1N1VphR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BCAC4CED6;
	Thu, 16 Jan 2025 05:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006298;
	bh=QheorW66Ni1CHDBZ7144PGRETCjK9izVtAoVmbXM2Xc=;
	h=Date:To:From:Subject:From;
	b=H1N1VphRkp1ZLVfCD/UVuGNHYb5dImC2bQ7lswsSgobxMbUmDZwcBefPErNOWF65M
	 HQL1LMS78XsUBPHLkGP+N+XTiI6F892duXXt8RKnqQ2jmC3U6Q8Tv5/l4m1pnmLi5R
	 bmtHYKzjIYHNay8EH7qVYLTZquag0hRNOKYDIGEY=
Date: Wed, 15 Jan 2025 21:44:57 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,wang.yaxin@zte.com.cn,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-filesystems-procrst-fix-possessive-form-of-process.patch removed from -mm tree
Message-Id: <20250116054457.E1BCAC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/filesystems/proc.rst: fix possessive form of "process"
has been removed from the -mm tree.  Its filename was
     documentation-filesystems-procrst-fix-possessive-form-of-process.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Documentation/filesystems/proc.rst: fix possessive form of "process"
Date: Fri Jan 10 04:38:41 PM PST 2025

The possessive form of "process" is "process's".  Fix up various
misdirected attempts at this.  Also reflow some paragraphs.

Cc: David Hildenbrand <david@redhat.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   34 ++++++++++++++-------------
 1 file changed, 18 insertions(+), 16 deletions(-)

--- a/Documentation/filesystems/proc.rst~documentation-filesystems-procrst-fix-possessive-form-of-process
+++ a/Documentation/filesystems/proc.rst
@@ -48,7 +48,7 @@ fixes/update part 1.1  Stefani Seibold <
   3.11	/proc/<pid>/patch_state - Livepatch patch operation state
   3.12	/proc/<pid>/arch_status - Task architecture specific information
   3.13  /proc/<pid>/fd - List of symlinks to open files
-  3.14  /proc/<pid/ksm_stat - Information about the process' ksm status.
+  3.14  /proc/<pid/ksm_stat - Information about the process's ksm status.
 
   4	Configuring procfs
   4.1	Mount options
@@ -485,14 +485,15 @@ Memory Area, or VMA) there is a series o
     THPeligible:           0
     VmFlags: rd ex mr mw me dw
 
-The first of these lines shows the same information as is displayed for the
-mapping in /proc/PID/maps.  Following lines show the size of the mapping
-(size); the size of each page allocated when backing a VMA (KernelPageSize),
-which is usually the same as the size in the page table entries; the page size
-used by the MMU when backing a VMA (in most cases, the same as KernelPageSize);
-the amount of the mapping that is currently resident in RAM (RSS); the
-process' proportional share of this mapping (PSS); and the number of clean and
-dirty shared and private pages in the mapping.
+The first of these lines shows the same information as is displayed for
+the mapping in /proc/PID/maps.  Following lines show the size of the
+mapping (size); the size of each page allocated when backing a VMA
+(KernelPageSize), which is usually the same as the size in the page table
+entries; the page size used by the MMU when backing a VMA (in most cases,
+the same as KernelPageSize); the amount of the mapping that is currently
+resident in RAM (RSS); the process's proportional share of this mapping
+(PSS); and the number of clean and dirty shared and private pages in the
+mapping.
 
 The "proportional set size" (PSS) of a process is the count of pages it has
 in memory, where each page is divided by the number of processes sharing it.
@@ -2233,8 +2234,8 @@ The number of open files for the process
 of stat() output for /proc/<pid>/fd for fast access.
 -------------------------------------------------------
 
-3.14 /proc/<pid/ksm_stat - Information about the process' ksm status
---------------------------------------------------------------------
+3.14 /proc/<pid/ksm_stat - Information about the process's ksm status
+---------------------------------------------------------------------
 When CONFIG_KSM is enabled, each process has this file which displays
 the information of ksm merging status.
 
@@ -2288,14 +2289,15 @@ memory consumed.
 ksm_merge_any
 ^^^^^^^^^^^^^
 
-It specifies whether the process'mm is added by prctl() into the candidate list
-of KSM or not, and if KSM scanning is fully enabled at process level.
+It specifies whether the process's 'mm is added by prctl() into the
+candidate list of KSM or not, and if KSM scanning is fully enabled at
+process level.
 
 ksm_mergeable
 ^^^^^^^^^^^^^
 
-It specifies whether any VMAs of the process'mm are currently applicable
-to KSM.
+It specifies whether any VMAs of the process''s mms are currently
+applicable to KSM.
 
 More information about KSM can be found in
 Documentation/admin-guide/mm/ksm.rst.
@@ -2329,7 +2331,7 @@ arguments are now protected against loca
 hidepid=invisible or hidepid=2 means hidepid=1 plus all /proc/<pid>/ will be
 fully invisible to other users.  It doesn't mean that it hides a fact whether a
 process with a specific pid value exists (it can be learned by other means, e.g.
-by "kill -0 $PID"), but it hides process' uid and gid, which may be learned by
+by "kill -0 $PID"), but it hides process's uid and gid, which may be learned by
 stat()'ing /proc/<pid>/ otherwise.  It greatly complicates an intruder's task of
 gathering information about running processes, whether some daemon runs with
 elevated privileges, whether other user runs some sensitive program, whether
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


