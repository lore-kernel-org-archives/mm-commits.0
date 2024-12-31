Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179E44C7D
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735605735; cv=none; b=IAR1FipvVLcPMJ1eq7Myp2Zbg+IzniCM3Z8wrbfpPyD3kH6UK1WQ3cjaSb0FF4Pmdo0BlGj7eh0i+n6zzD+gkvP0HSgmJYQ9GzBWl3pijlyzfP2kPhFbt0OofpOV6O7FoqaeYoBwvAgMq8A7qfvlLPiC0+j0OwbPKRXT1JvmxPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735605735; c=relaxed/simple;
	bh=p0sZgciWrmRBQCBtKPG/hiQJFbAs1kHBshLdcfYbirU=;
	h=Date:To:From:Subject:Message-Id; b=AqEyJHDiEozaob4LkRHunugZr2DUlQQuJH7q0KMtYhicg+ca44KK/OfU+KDQYU7o2gg/gkLJNu8VWXz742PDJEJsMsAaFWO0WZh6zQvKNnJLsSpIF0foLO3qeoQUMIJC4QUOVuc5qxFd5gfHaN9g/87c0XQfjxMCQW5JsBkN2PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ClAq2O33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ClAq2O33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D68C4CED0;
	Tue, 31 Dec 2024 00:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735605734;
	bh=p0sZgciWrmRBQCBtKPG/hiQJFbAs1kHBshLdcfYbirU=;
	h=Date:To:From:Subject:From;
	b=ClAq2O33GvXGukz7ZEpg8rHy8C+ExVMgsM0CtpPcMp8lbZmmjEZW31Cts+GO6Iz1k
	 Jmxu+HGAJIFwmQg6JGetCffmy1Vjo95EXWLz5UBYX/aZJV98G+oQUzPIPPeW2chVAS
	 dAP1aIPwd3ZN+tMnsY/rvUynqOyIyCNlHz3CC2d4=
Date: Mon, 30 Dec 2024 16:42:13 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,song@kernel.org,shuah@kernel.org,samitolvanen@google.com,rostedt@goodmis.org,rmoar@google.com,richard@nod.at,pmladek@suse.com,petr.pavlu@suse.com,peterz@infradead.org,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mbenes@suse.cz,mark.rutland@arm.com,luto@kernel.org,kirill.shutemov@linux.intel.com,jpoimboe@kernel.org,johannes@sipsolutions.net,joe.lawrence@redhat.com,jikos@kernel.org,jason.wessel@windriver.com,hpa@zytor.com,dianders@chromium.org,davidgow@google.com,dave.hansen@linux.intel.com,danielt@kernel.org,da.gomez@samsung.com,brendan.higgins@linux.dev,bp@alien8.de,anton.ivanov@cambridgegreys.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-pat-cpa-test-fix-length-for-cpa_array-test.patch added to mm-unstable branch
Message-Id: <20241231004214.78D68C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm/pat: cpa-test: fix length for CPA_ARRAY test
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-pat-cpa-test-fix-length-for-cpa_array-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-pat-cpa-test-fix-length-for-cpa_array-test.patch

This patch will later appear in the mm-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: x86/mm/pat: cpa-test: fix length for CPA_ARRAY test
Date: Fri, 27 Dec 2024 09:28:18 +0200

Patch series "x86/module: rework ROX cache to avoid writable copy".

Following Peter's comments [1] these patches rework handling of ROX caches
for module text allocations.  

Instead of using a writable copy that really complicates alternatives
patching, temporarily remap parts of a large ROX page as RW for the time
of module formation and then restore it's ROX protections when the module
is ready.

To keep the ROX memory mapped with large pages, make set_memory code
capable of restoring large pages (more details are in patch 3).

The patches also available in git
https://git.kernel.org/rppt/h/execmem/x86-rox/v8

[1] https://lore.kernel.org/all/20241209083818.GK8562@noisy.programming.kicks-ass.net


This patch (of 8):

The CPA_ARRAY test always uses len[1] as numpages argument to
change_page_attr_set() although the addresses array is different each
iteration of the test loop.

Replace len[1] with len[i] to have numpages matching the addresses array.

Link: https://lkml.kernel.org/r/20241227072825.1288491-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20241227072825.1288491-2-rppt@kernel.org
Fixes: ecc729f1f471 ("x86/mm/cpa: Add ARRAY and PAGES_ARRAY selftests")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Daniel Thompson <danielt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Gow <davidgow@google.com>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <song@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/cpa-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/pat/cpa-test.c~x86-mm-pat-cpa-test-fix-length-for-cpa_array-test
+++ a/arch/x86/mm/pat/cpa-test.c
@@ -183,7 +183,7 @@ static int pageattr_test(void)
 			break;
 
 		case 1:
-			err = change_page_attr_set(addrs, len[1], PAGE_CPA_TEST, 1);
+			err = change_page_attr_set(addrs, len[i], PAGE_CPA_TEST, 1);
 			break;
 
 		case 2:
_

Patches currently in -mm which might be from rppt@kernel.org are

x86-mm-pat-cpa-test-fix-length-for-cpa_array-test.patch
x86-mm-pat-drop-duplicate-variable-in-cpa_flush.patch
execmem-add-api-for-temporal-remapping-as-rw-and-restoring-rox-afterwards.patch
module-introduce-module_state_gone.patch
modules-switch-to-execmem-api-for-remapping-as-rw-and-restoring-rox.patch
revert-x86-module-prepare-module-loading-for-rox-allocations-of-text.patch
module-drop-unused-module_writable_address.patch

