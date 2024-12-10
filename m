Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A9B1D7E4E
	for <mm-commits@vger.kernel.org>; Tue, 10 Dec 2024 03:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733802940; cv=none; b=lxL2oqB1WiCxXmUeSCo37FsJ3i8NyG5Rj4qenxemw8yNOHK/LtSAQNWLzL6RiyEE27KqcK6CtCwhmDZ90+XAjvOZ+l6obpuzkKsU0Wjv5CNKx/zlJoVsv+QtFGU3JMhH+DDdbbawUBa/7Rsnpj4jzdFdEopF3AXDwl/IZjDlepM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733802940; c=relaxed/simple;
	bh=wCkSNDRf1dhcK0HVWUCJT41ital/CVTXp2HmjKFpYU0=;
	h=Date:To:From:Subject:Message-Id; b=WtPBLhVPIXeOughwtKfOglz6LUT5EdruhhaJ4w5v8Ba0bcTZkLI0tVjMWKeJscCJresYGEFKH5nTzHuYPrqM2apclGu4+MgBlHzvApUQVKMh5ql+9u7xZput5lczjKOb5koKx+A8CiqVndqYdpAdQCiYT+WJExpKsNiNPPFyFRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tAmTpw3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tAmTpw3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56794C4CED6;
	Tue, 10 Dec 2024 03:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733802940;
	bh=wCkSNDRf1dhcK0HVWUCJT41ital/CVTXp2HmjKFpYU0=;
	h=Date:To:From:Subject:From;
	b=tAmTpw3ON7RYWKgYX52nSZkRToMMluaiINMRklD7Y/f3NvK+I4cPz35oPtErlmsFE
	 4dSQwbEHfAx0zDqFFZB0XpXwRDaBZG5eNzlGLzvxiG4jsZaUJ/tH6zXbJRfUcEgAF+
	 M0Mwg4e7C2EfPezzMQ2JriZ2C2hUd2O48vtjulaU=
Date: Mon, 09 Dec 2024 19:55:39 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,david@redhat.com,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless.patch added to mm-unstable branch
Message-Id: <20241210035540.56794C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove an avoidable load of page refcount in page_ref_add_unless
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless.patch

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
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: mm: remove an avoidable load of page refcount in page_ref_add_unless
Date: Sat, 7 Dec 2024 09:29:31 +0100

Explicitly pre-checking the count adds nothing as atomic_add_unless starts
with doing the same thing.  iow no functional changes.

disasm of stock filemap_get_read_batch from perf top while running
readseek2_processes -t 24:

  0.04 │ cb:   mov    0x34(%rbx),%eax           # first load
 73.11 │       test   %eax,%eax
       │     ↓ je     1bd
  0.09 │       mov    0x34(%rbx),%eax           # second load
  1.01 │ d9:   test   %eax,%eax
       │     ↓ je     1bd
  0.06 │       lea    0x1(%rax),%edx
  0.00 │       lea    0x34(%rbx),%r14
  0.00 │       lock   cmpxchg %edx,0x34(%rbx)
 14.06 │     ↑ jne    d9

Link: https://lkml.kernel.org/r/20241207082931.1707465-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page_ref.h~mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless
+++ a/include/linux/page_ref.h
@@ -234,7 +234,7 @@ static inline bool page_ref_add_unless(s
 
 	rcu_read_lock();
 	/* avoid writing to the vmemmap area being remapped */
-	if (!page_is_fake_head(page) && page_ref_count(page) != u)
+	if (!page_is_fake_head(page))
 		ret = atomic_add_unless(&page->_refcount, nr, u);
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from mjguzik@gmail.com are

mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless.patch
get_task_exe_file-check-pf_kthread-locklessly.patch

