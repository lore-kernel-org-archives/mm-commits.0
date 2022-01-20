Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5844EC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236186AbiATCIE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50272 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiATCID (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 822F8B81B3B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA05C004E1;
        Thu, 20 Jan 2022 02:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644481;
        bh=S7e8CuGvJPJ35GtdLmKgBe36jQTkMKEoJL47rd69lXM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gKRapUQjGGOrDfb63tghnJqxmS5uuXiq6+yH4U5rg0W5ThQrerMgdcLCVxtEfy/6p
         D4e0AzivS1rILUAKgUTPaUXkhem5vgT+cc5/EK6uK2LOfcuZDJGD9kEJN8YHST8EtB
         XdXgEv3J0o0WTDrB7LwP89sRKGsQDCGK4/t6i0oQ=
Date:   Wed, 19 Jan 2022 18:08:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christian.brauner@ubuntu.com,
        dhowells@redhat.com, hch@infradead.org, hdegoede@redhat.com,
        linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk
Subject:  [patch 06/55] proc: make the proc_create[_data]() stubs
 static inlines
Message-ID: <20220120020800.1TImEbrhi%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>
Subject: proc: make the proc_create[_data]() stubs static inlines

Change the proc_create[_data]() stubs which are used when CONFIG_PROC_FS
is not set from #defines to a static inline stubs.

Thix should fix clang -Werror builds failing due to errors like this:

drivers/platform/x86/thinkpad_acpi.c:918:30: error: unused variable
 'dispatch_proc_ops' [-Werror,-Wunused-const-variable]

Fixing this in include/linux/proc_fs.h should ensure that the same issue
is also fixed in any other drivers hitting the same -Werror issue.

[akpm@linux-foundation.org: fix CONFIG_PROC_FS=n]
[akpm@linux-foundation.org: fix arch/sparc/kernel/led.c]
[akpm@linux-foundation.org: fix build]
Link: https://lkml.kernel.org/r/20211116131112.508304-1-hdegoede@redhat.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/led.c |    8 +++-----
 include/linux/proc_fs.h |   12 ++++++++++--
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/arch/sparc/kernel/led.c~proc-make-the-proc_create-stubs-static-inlines
+++ a/arch/sparc/kernel/led.c
@@ -114,18 +114,16 @@ static const struct proc_ops led_proc_op
 };
 #endif
 
-static struct proc_dir_entry *led;
-
 #define LED_VERSION	"0.1"
 
 static int __init led_init(void)
 {
 	timer_setup(&led_blink_timer, led_blink, 0);
 
-	led = proc_create("led", 0, NULL, &led_proc_ops);
-	if (!led)
+#ifdef CONFIG_PROC_FS
+	if (!proc_create("led", 0, NULL, &led_proc_ops))
 		return -ENOMEM;
-
+#endif
 	printk(KERN_INFO
 	       "led: version %s, Lars Kotthoff <metalhead@metalhead.ws>\n",
 	       LED_VERSION);
--- a/include/linux/proc_fs.h~proc-make-the-proc_create-stubs-static-inlines
+++ a/include/linux/proc_fs.h
@@ -178,8 +178,16 @@ static inline struct proc_dir_entry *pro
 #define proc_create_seq(name, mode, parent, ops) ({NULL;})
 #define proc_create_single(name, mode, parent, show) ({NULL;})
 #define proc_create_single_data(name, mode, parent, show, data) ({NULL;})
-#define proc_create(name, mode, parent, proc_ops) ({NULL;})
-#define proc_create_data(name, mode, parent, proc_ops, data) ({NULL;})
+
+static inline struct proc_dir_entry *
+proc_create(const char *name, umode_t mode, struct proc_dir_entry *parent,
+	    const struct proc_ops *proc_ops)
+{ return NULL; }
+
+static inline struct proc_dir_entry *
+proc_create_data(const char *name, umode_t mode, struct proc_dir_entry *parent,
+		 const struct proc_ops *proc_ops, void *data)
+{ return NULL; }
 
 static inline void proc_set_size(struct proc_dir_entry *de, loff_t size) {}
 static inline void proc_set_user(struct proc_dir_entry *de, kuid_t uid, kgid_t gid) {}
_
