Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBD5C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5523D61284
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbhKICeb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:34:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICea (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:34:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 027BF61208;
        Tue,  9 Nov 2021 02:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425105;
        bh=IQyKZcygio3z+tyeKmy/UrYdywwuBxg47jB9qC4O84g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2shGJJJnRUSllrfCdRr7OrxGnnBdSXqMvHCg/tkpiHnE8hNSRKh8U2lVKuciedJwL
         ETzOsENyYpq6bZcpeHJzF1R+f5O5f5T1B/psnz7rCV9LXJl1nR9Tof7lpv+kZWxw1U
         ZYFq9KSHpLg5aC4WhX1xJmGVQ3DbRuS6ce48KrHs=
Date:   Mon, 08 Nov 2021 18:31:44 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, david@redhat.com,
        dyoung@redhat.com, hpa@zytor.com, jasowang@redhat.com,
        jgross@suse.com, linux-mm@kvack.org, mhocko@suse.com,
        mingo@redhat.com, mm-commits@vger.kernel.org, mst@redhat.com,
        osalvador@suse.de, rafael.j.wysocki@intel.com, rppt@kernel.org,
        sstabellini@kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, vgoyal@redhat.com
Subject:  [patch 07/87] proc/vmcore: let pfn_is_ram() return a bool
Message-ID: <20211109023144.jG29wo3AQ%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: proc/vmcore: let pfn_is_ram() return a bool

The callback should deal with errors internally, it doesn't make sense to
expose these via pfn_is_ram().  We'll rework the callbacks next.  Right
now we consider errors as if "it's RAM"; no functional change.

Link: https://lkml.kernel.org/r/20211005121430.30136-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/vmcore.c~proc-vmcore-let-pfn_is_ram-return-a-bool
+++ a/fs/proc/vmcore.c
@@ -84,11 +84,11 @@ void unregister_oldmem_pfn_is_ram(void)
 }
 EXPORT_SYMBOL_GPL(unregister_oldmem_pfn_is_ram);
 
-static int pfn_is_ram(unsigned long pfn)
+static bool pfn_is_ram(unsigned long pfn)
 {
 	int (*fn)(unsigned long pfn);
 	/* pfn is ram unless fn() checks pagetype */
-	int ret = 1;
+	bool ret = true;
 
 	/*
 	 * Ask hypervisor if the pfn is really ram.
@@ -97,7 +97,7 @@ static int pfn_is_ram(unsigned long pfn)
 	 */
 	fn = oldmem_pfn_is_ram;
 	if (fn)
-		ret = fn(pfn);
+		ret = !!fn(pfn);
 
 	return ret;
 }
@@ -124,7 +124,7 @@ ssize_t read_from_oldmem(char *buf, size
 			nr_bytes = count;
 
 		/* If pfn is not ram, return zeros for sparse dump files */
-		if (pfn_is_ram(pfn) == 0)
+		if (!pfn_is_ram(pfn))
 			memset(buf, 0, nr_bytes);
 		else {
 			if (encrypted)
_
