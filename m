Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA70A143C56
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291657; cv=none; b=jdS4Y4+Hv3WxuGdkRbdCXgCjiJlYU8IRt7C/o7ieQG5GNpXdgv6JnJ2f3poKAdZ7fdzkZvkwCfkHeLAycrdvir8xWh9WgotntgDbvAAgzM9Usf1mckiell4x7XjhSAr+S4YCvPyPjjOxojM4qLBTRRKLy+bDV0p/9Clf9ER7Lz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291657; c=relaxed/simple;
	bh=Y2SlzAjVptXuJYzSrFJMyIcYY6QJaUhoJeETR+hp2Pg=;
	h=Date:To:From:Subject:Message-Id; b=Oga6G/HGG6LybkbYUuFj3BY5g8Sl4cBm8rWBtmwmJBQAvUuNzvXcePBcn2ExMqxkiY+gTfPlW/4a/I4iLC271kh1lkvLBHqSETVI2aXJ5wjd6qSAFln8+Qqn2/ualPrfSyzihQRCL05p2eAgZ4DYGYmjUQPWB7wiO3ftWB6mTBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i16AKvma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i16AKvma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9946BC32782;
	Tue, 25 Jun 2024 05:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291657;
	bh=Y2SlzAjVptXuJYzSrFJMyIcYY6QJaUhoJeETR+hp2Pg=;
	h=Date:To:From:Subject:From;
	b=i16AKvmaQ9Y6ugGy4ZQ7UnR5UuGZQ7lwPnh5XjmoPw37bqYKd/aZFB+OEr7TXSbj2
	 bCVT+JerDzYOvCWnnvCJf7vbylxa4DgADlct2kG2QVMSNAqeXB5uLfiZRf89xUizFx
	 Ukuu0hn4Q7QGOkw135AeLw712tfk0xfvNIEt7p6E=
Date: Mon, 24 Jun 2024 22:00:57 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.com,kirill.shutemov@linux.intel.com,ioworker0@gmail.com,corbet@lwn.net,adobriyan@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch removed from -mm tree
Message-Id: <20240625050057.9946BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/admin-guide/mm/pagemap.rst: drop "Using pagemap to do something useful"
has been removed from the -mm tree.  Its filename was
     documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: Documentation/admin-guide/mm/pagemap.rst: drop "Using pagemap to do something useful"
Date: Fri, 7 Jun 2024 14:23:57 +0200

That example was added in 2008.  In 2015, we restricted access to the PFNs
in the pagemap to CAP_SYS_ADMIN, making that approach quite less usable.

It's 2024 now, and using that racy and low-lewel mechanism to calculate
the USS should not be considered a good example anymore.  /proc/$pid/smaps
and /proc/$pid/smaps_rollup can do a much better job without any of that
low-level handling.

Let's just drop that example.

Link: https://lkml.kernel.org/r/20240607122357.115423-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Oscar Salvador <osalvador@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/pagemap.rst |   21 ---------------------
 1 file changed, 21 deletions(-)

--- a/Documentation/admin-guide/mm/pagemap.rst~documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful
+++ a/Documentation/admin-guide/mm/pagemap.rst
@@ -173,27 +173,6 @@ LRU related page flags
 The page-types tool in the tools/mm directory can be used to query the
 above flags.
 
-Using pagemap to do something useful
-====================================
-
-The general procedure for using pagemap to find out about a process' memory
-usage goes like this:
-
- 1. Read ``/proc/pid/maps`` to determine which parts of the memory space are
-    mapped to what.
- 2. Select the maps you are interested in -- all of them, or a particular
-    library, or the stack or the heap, etc.
- 3. Open ``/proc/pid/pagemap`` and seek to the pages you would like to examine.
- 4. Read a u64 for each page from pagemap.
- 5. Open ``/proc/kpagecount`` and/or ``/proc/kpageflags``.  For each PFN you
-    just read, seek to that entry in the file, and read the data you want.
-
-For example, to find the "unique set size" (USS), which is the amount of
-memory that a process is using that is not shared with any other process,
-you can go through every map in the process, find the PFNs, look those up
-in kpagecount, and tally up the number of pages that are only referenced
-once.
-
 Exceptions for Shared Memory
 ============================
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

