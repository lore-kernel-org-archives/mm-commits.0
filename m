Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4317337E5FE
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622927; cv=none; b=IYBF2Jl5qI0t0C6MRvc5NWj8CO7R8cIjk4TRTZbBGOLsWblakL7zC/E8OWUU5C3/LRwaWOo8GsJlWmYaHIpDJmEho/oKxIkt1hj8OC+qjfqQ14ubb554gp0GYGFHzzvibVRKcQlqzHT9FJmDx0WhZPsgaRUsyoON+GBZaOFc5Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622927; c=relaxed/simple;
	bh=iFeXrHjR+h8MHVdluvda90Tlq4l718uof3ZwS1rGNZc=;
	h=Date:To:From:Subject:Message-Id; b=JUZohymVc+JALl0Vcq7MgU54f4kvXUcqgadiSZy09bqUiV/gKfRCYOHoUJ0o15sb0Sma7NxYDLwN8I5HPQnyrgzdTJ5Fke3/QnK98LJ31i/GGovB5GNxL81C7m35apl/uQbHyY/E4bleUtXd/mzUx9k6PCM6UfgPZ8J5NyGN2z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M4E82hXU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M4E82hXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D631F000E9;
	Tue, 25 Aug 2026 01:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622924;
	bh=iL5zsy4fXCsJIRXpZ+wnNdc2N8qFS5ba+m2Sy9BkLck=;
	h=Date:To:From:Subject;
	b=M4E82hXU4wY5xeXeXa0tyRls8/lml21L1lBFgnnCtGmCnK+O6egyxobF0hn1UGC9G
	 LntFlcHkadBnlZdflikcwjdJ0ut8BmtyfhzUnhPC+S1F2UkO+53cf9NtpC8emumtRf
	 Ut+3234Rj0Kb6o1BX9cL5FqruE5oMxyw3Zh1FSCU=
Date: Mon, 24 Aug 2026 18:55:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,liam@infradead.org,jannh@google.com,david@kernel.org,arnd@arndb.de,anshuman.khandual@arm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch removed from -mm tree
Message-Id: <20260825015524.17D631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add drivers/char/mem.c to mm misc, memory mapping sections
has been removed from the -mm tree.  Its filename was
     maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: MAINTAINERS: add drivers/char/mem.c to mm misc, memory mapping sections
Date: Wed, 12 Aug 2026 08:43:31 +0100

This file is a 'special' driver that implements /dev/zero and /dev/mem
among other things.

As such it makes sense for mm to be cc'd on mails and to have some say in
how things are changed there, so add it to the mm misc section.

Uniquely, it provides the 'old way' of obtaining an anonymous mapping -
MAP_PRIVATE of /dev/zero - so is directly tied to memory mapping,
therefore also add it to the memory mapping section.

scripts/get_maintainer.pl copes perfectly fine with files in multiple
sections so everything should work correctly.

Link: https://lore.kernel.org/20260812-add-drivers-mem-to-mm-maintainers-v1-1-6218b861f4c8@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: SJ Park <sj@kernel.org>
Reviewed-by: Anshuman Khandual<anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-drivers-char-memc-to-mm-misc-memory-mapping-sections
+++ a/MAINTAINERS
@@ -17115,6 +17115,7 @@ F:	Documentation/ABI/testing/sysfs-kerne
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
+F:	drivers/char/mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
@@ -17319,6 +17320,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	drivers/char/mem.c
 F:	include/trace/events/mmap.h
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
_

Patches currently in -mm which might be from ljs@kernel.org are


