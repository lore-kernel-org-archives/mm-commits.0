Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB29C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 22:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1E1D63223
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 22:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhKPWDe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Nov 2021 17:03:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:39974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231629AbhKPWDe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Nov 2021 17:03:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C79B8619FA;
        Tue, 16 Nov 2021 22:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637100037;
        bh=fP/hsAnhizUXdeenkblntCd84keQUEZeLqOdj7I1Ao4=;
        h=Date:From:To:Subject:From;
        b=jRdDuHhvG+N4FxqRCcnjPI6ZYz9XXepuY3aBZWiZc4IQsgEO7h/uqFFeCWiB1P8SJ
         ColXeoPihBHyN9wzvOxcEFvPAKgxKNhvFa4u0rbH5k8z2yfOFv70wYQ02aJ6m0t998
         f+jnXFhkX3S4dE/wfwBkLeVXvRrH7EzOihdyIkSI=
Date:   Tue, 16 Nov 2021 14:00:36 -0800
From:   akpm@linux-foundation.org
To:     christian@brauner.io, dhowells@redhat.com, hch@infradead.org,
        hdegoede@redhat.com, lkp@intel.com, mm-commits@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject:  + proc-make-the-proc_create-stubs-static-inlines.patch
 added to -mm tree
Message-ID: <20211116220036.N8f_s3cLJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc: Make the proc_create[_data]() stubs static inlines
has been added to the -mm tree.  Its filename is
     proc-make-the-proc_create-stubs-static-inlines.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-make-the-proc_create-stubs-static-inlines.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-make-the-proc_create-stubs-static-inlines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hans de Goede <hdegoede@redhat.com>
Subject: proc: Make the proc_create[_data]() stubs static inlines

Change the proc_create[_data]() stubs which are used when CONFIG_PROC_FS
is not set from #defines to a static inline stubs.

Thix should fix clang -Werror builds failing due to errors like this:

drivers/platform/x86/thinkpad_acpi.c:918:30: error: unused variable
 'dispatch_proc_ops' [-Werror,-Wunused-const-variable]

Fixing this in include/linux/proc_fs.h should ensure that the same issue
is also fixed in any other drivers hitting the same -Werror issue.

Link: https://lkml.kernel.org/r/20211116131112.508304-1-hdegoede@redhat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/proc_fs.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/proc_fs.h~proc-make-the-proc_create-stubs-static-inlines
+++ a/include/linux/proc_fs.h
@@ -178,8 +178,14 @@ static inline struct proc_dir_entry *pro
 #define proc_create_seq(name, mode, parent, ops) ({NULL;})
 #define proc_create_single(name, mode, parent, show) ({NULL;})
 #define proc_create_single_data(name, mode, parent, show, data) ({NULL;})
-#define proc_create(name, mode, parent, proc_ops) ({NULL;})
-#define proc_create_data(name, mode, parent, proc_ops, data) ({NULL;})
+
+static inline struct proc_dir_entry *proc_create(
+	const char *, umode_t, struct proc_dir_entry *, const struct proc_ops *)
+{ return NULL; }
+
+static inline struct proc_dir_entry *proc_create_data(
+	const char *, umode_t, struct proc_dir_entry *, const struct proc_ops *, void *)
+{ return NULL; }
 
 static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
 static inline void proc_set_user(struct proc_dir_entry *de, kuid_t uid, kgid_t gid) {}
_

Patches currently in -mm which might be from hdegoede@redhat.com are

proc-make-the-proc_create-stubs-static-inlines.patch

