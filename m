Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DCFC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 21:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344091AbhKXVjV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 16:39:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344088AbhKXVjU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 16:39:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13F3C61038;
        Wed, 24 Nov 2021 21:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637789770;
        bh=75i6PmALCISUdUzt2/xrKkHQZzlaUIVfo/v9cBz9c10=;
        h=Date:From:To:Subject:From;
        b=q3YlS4RcjKDyt1UL6tJyGmuD1B463keJkfwtkLsP1HonnZdYcM30WGGujw7BWtG7I
         Ss4Oz6eTvm3X4ZBynj+6VX0BKuPjn1e4THlRksA7LPDWXd1qf0HUSFbVAdoJWzjDyr
         qgfIZT4ctPZemX6ESru30n21mD0iURSSJw/SWkjQ=
Date:   Wed, 24 Nov 2021 13:36:09 -0800
From:   akpm@linux-foundation.org
To:     agruenba@redhat.com, catalin.marinas@arm.com, dsterba@suse.com,
        josef@toxicpanda.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk, will@kernel.org, willy@infradead.org
Subject:  +
 mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults.patch
 added to -mm tree
Message-ID: <20211124213609.l3uis0uJE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce fault_in_exact_writeable() to probe for sub-page faults
has been added to the -mm tree.  Its filename is
     mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: introduce fault_in_exact_writeable() to probe for sub-page faults

Patch series "Avoid live-lock in fault-in+uaccess loops with sub-page faults".

There are a few places in the filesystem layer where a uaccess is
performed in a loop with page faults disabled, together with a
fault_in_*() call to pre-fault the pages.  On architectures like arm64
with MTE (memory tagging extensions) or SPARC ADI, even if the
fault_in_*() succeeded, the uaccess can still fault indefinitely.

In general this is not an issue since such code restarts the fault_in_*()
from where the uaccess failed, therefore guaranteeing forward progress. 
The btrfs search_ioctl(), however, rewinds the fault_in_*() position and
it can live-lock.  This was reported by Al here:

https://lore.kernel.org/r/YSqOUb7yZ7kBoKRY@zeniv-ca.linux.org.uk

There's also an analysis by Al of other fault-in places:

https://lore.kernel.org/r/YSldx9uhMYhT/G8X@zeniv-ca.linux.org.uk

and another sub-thread on the same topic:

https://lore.kernel.org/r/YXBFqD9WVuU8awIv@arm.com

So far only btrfs search_ioctl() seems to be affected and that's what this
series addresses.  The existing loops like generic_perform_write() already
guarantee forward progress.

Andreas raised a concern about O_DIRECT accesses since on fault the user
address is rewound to a block size boundary.  I tried ext4, btrfs and gfs2
and I could not get any of them to live-lock.  Depending on the alignment
of the user buffer (page or not), I found two behaviours:

- the copy to or from the user buffer succeeds entirely if it goes
  through the kernel mapping (GUP, kmap'ed page; user MTE tags are not
  checked) or

- the copy partially succeeds after a few attempts at uaccess on the
  faulting same address (the highest number of attempts in my tests was
  11 with btrfs).

Given the high cost of such sub-page probing (which is done prior to the
uaccess) my proposal is to only change the btrfs search_ioctl() (as per
the last patch).  We can extend the API and call places in the future if
needed but I hope filesystems already deal with this in other ways.


This patch (of 3):

On hardware with features like arm64 MTE or SPARC ADI, an access fault can
be triggered at sub-page granularity.  Depending on how the fault_in_*()
functions are used, the caller can get into a live-lock by continuously
retrying the fault-in on an address different from the one where the
uaccess failed.

In the majority of cases progress is ensured by the following conditions:

1. copy_{to,from}_user() guarantees at least one byte access if the user
   address is not faulting;

2. The fault_in_*() is attempted on the next address that could not be
   accessed by copy_*_user().

In the places where the above conditions are not met or the
fault-in/uaccess loop does not have a mechanism to bail out, the
fault_in_exact_writeable() ensures that the arch code will probe the range
in question at a sub-page fault granularity (e.g.  16 bytes for arm64
MTE).  For large ranges, this is significantly more expensive than the
non-exact versions which probe a single byte in each page or use GUP.

The architecture code has to select ARCH_HAS_SUBPAGE_FAULTS and implement
probe_user_writeable().

Link: https://lkml.kernel.org/r/20211124192024.2408218-1-catalin.marinas@arm.com
Link: https://lkml.kernel.org/r/20211124192024.2408218-2-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig            |    7 +++++++
 include/linux/pagemap.h |    1 +
 include/linux/uaccess.h |   21 +++++++++++++++++++++
 mm/gup.c                |   19 +++++++++++++++++++
 4 files changed, 48 insertions(+)

--- a/arch/Kconfig~mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults
+++ a/arch/Kconfig
@@ -27,6 +27,13 @@ config HAVE_IMA_KEXEC
 config SET_FS
 	bool
 
+config ARCH_HAS_SUBPAGE_FAULTS
+	bool
+	help
+	  Select if the architecture can check permissions at sub-page
+	  granularity (e.g. arm64 MTE). The probe_user_*() functions
+	  must be implemented.
+
 config HOTPLUG_SMT
 	bool
 
--- a/include/linux/pagemap.h~mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults
+++ a/include/linux/pagemap.h
@@ -910,6 +910,7 @@ void folio_add_wait_queue(struct folio *
  * Fault in userspace address range.
  */
 size_t fault_in_writeable(char __user *uaddr, size_t size);
+size_t fault_in_exact_writeable(char __user *uaddr, size_t size);
 size_t fault_in_safe_writeable(const char __user *uaddr, size_t size);
 size_t fault_in_readable(const char __user *uaddr, size_t size);
 
--- a/include/linux/uaccess.h~mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults
+++ a/include/linux/uaccess.h
@@ -271,6 +271,27 @@ static inline bool pagefault_disabled(vo
  */
 #define faulthandler_disabled() (pagefault_disabled() || in_atomic())
 
+#ifndef CONFIG_ARCH_HAS_SUBPAGE_FAULTS
+/**
+ * probe_user_writable: probe for sub-page faults in the user range
+ * @uaddr: start of address range
+ * @size: size of address range
+ *
+ * Returns the number of bytes not accessible (like copy_to_user() and
+ * copy_from_user()).
+ *
+ * Architectures that can generate sub-page faults (e.g. arm64 MTE) should
+ * implement this function. It is expected that the caller checked for the
+ * write permission of each page in the range either by put_user() or GUP.
+ * The architecture port can implement a more efficient get_user() probing of
+ * the range if sub-page faults are triggered by either a load or store.
+ */
+static inline size_t probe_user_writable(void __user *uaddr, size_t size)
+{
+	return 0;
+}
+#endif
+
 #ifndef ARCH_HAS_NOCACHE_UACCESS
 
 static inline __must_check unsigned long
--- a/mm/gup.c~mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults
+++ a/mm/gup.c
@@ -1694,6 +1694,25 @@ out:
 }
 EXPORT_SYMBOL(fault_in_writeable);
 
+/**
+ * fault_in_exact_writeable - fault in userspace address range for writing,
+ *			      potentially checking for sub-page faults
+ * @uaddr: start of address range
+ * @size: size of address range
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
+ */
+size_t fault_in_exact_writeable(char __user *uaddr, size_t size)
+{
+	size_t accessible = size - fault_in_writeable(uaddr, size);
+
+	if (accessible)
+		accessible -= probe_user_writable(uaddr, accessible);
+	return size - accessible;
+}
+EXPORT_SYMBOL(fault_in_exact_writeable);
+
 /*
  * fault_in_safe_writeable - fault in an address range for writing
  * @uaddr: start of address range
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-introduce-fault_in_exact_writeable-to-probe-for-sub-page-faults.patch
arm64-add-support-for-sub-page-faults-user-probing.patch
btrfs-avoid-live-lock-in-search_ioctl-on-hardware-with-sub-page-faults.patch

