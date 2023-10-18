Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2B76CDB482
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbjJRVnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjJRVns (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:43:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF9D111
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:43:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A48C433C8;
        Wed, 18 Oct 2023 21:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697665425;
        bh=UcammtXLq2J73eFztPweJgM/IiTXuH8/ZLoS5c3wwhI=;
        h=Date:To:From:Subject:From;
        b=MIJCf63qGxh3MTMO+qQz8xSr7BnxYvvesB6etBVI84bry01N4PPStfua4/TFNykpQ
         0eCxU0WE2FjcXcketwWiLafyurevZWRAqJZkIj5CCmt4JDjW87qAKo1iL+h/B0JSsL
         xIxNrSqyzefwYKPiqGLGOZ82lMWf+NeYhcMA7OLI=
Date:   Wed, 18 Oct 2023 14:43:45 -0700
To:     mm-commits@vger.kernel.org, tiwai@suse.de, tglx@linutronix.de,
        keescook@chromium.org, adobriyan@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] extract-and-use-file_line-macro.patch removed from -mm tree
Message-Id: <20231018214345.D2A48C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: extract and use FILE_LINE macro
has been removed from the -mm tree.  Its filename was
     extract-and-use-file_line-macro.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: extract and use FILE_LINE macro
Date: Sat, 16 Sep 2023 21:21:31 +0300

Extract nifty FILE_LINE useful for printk style debugging:

	printk("%s\n", FILE_LINE);

It should not be used en mass probably because __FILE__ string literals
can be merged while FILE_LINE's won't. But for debugging it is what
the doctor ordered.

Don't add leading and trailing underscores, they're painful to type. 
Trust me, I've tried both versions.

Link: https://lkml.kernel.org/r/ebf12ac4-5a61-4b12-b8b0-1253eb371332@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fortify-string.h |    2 +-
 include/linux/stringify.h      |    2 ++
 include/linux/timer.h          |    3 +--
 sound/pci/asihpi/hpidebug.h    |    9 ++++-----
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/fortify-string.h~extract-and-use-file_line-macro
+++ a/include/linux/fortify-string.h
@@ -643,7 +643,7 @@ __FORTIFY_INLINE bool fortify_memcpy_chk
 				     __q_size_field, #op),		\
 		  #op ": detected field-spanning write (size %zu) of single %s (size %zu)\n", \
 		  __fortify_size,					\
-		  "field \"" #p "\" at " __FILE__ ":" __stringify(__LINE__), \
+		  "field \"" #p "\" at " FILE_LINE,			\
 		  __p_size_field);					\
 	__underlying_##op(p, q, __fortify_size);			\
 })
--- a/include/linux/stringify.h~extract-and-use-file_line-macro
+++ a/include/linux/stringify.h
@@ -9,4 +9,6 @@
 #define __stringify_1(x...)	#x
 #define __stringify(x...)	__stringify_1(x)
 
+#define FILE_LINE	__FILE__ ":" __stringify(__LINE__)
+
 #endif	/* !__LINUX_STRINGIFY_H */
--- a/include/linux/timer.h~extract-and-use-file_line-macro
+++ a/include/linux/timer.h
@@ -77,8 +77,7 @@ struct timer_list {
 		.entry = { .next = TIMER_ENTRY_STATIC },	\
 		.function = (_function),			\
 		.flags = (_flags),				\
-		__TIMER_LOCKDEP_MAP_INITIALIZER(		\
-			__FILE__ ":" __stringify(__LINE__))	\
+		__TIMER_LOCKDEP_MAP_INITIALIZER(FILE_LINE)	\
 	}
 
 #define DEFINE_TIMER(_name, _function)				\
--- a/sound/pci/asihpi/hpidebug.h~extract-and-use-file_line-macro
+++ a/sound/pci/asihpi/hpidebug.h
@@ -29,16 +29,15 @@ enum { HPI_DEBUG_LEVEL_ERROR = 0,	/* alw
    the start of each message, eg see linux kernel hpios.h */
 
 #ifdef SOURCEFILE_NAME
+#undef FILE_LINE
 #define FILE_LINE  SOURCEFILE_NAME ":" __stringify(__LINE__) " "
-#else
-#define FILE_LINE  __FILE__ ":" __stringify(__LINE__) " "
 #endif
 
 #define HPI_DEBUG_ASSERT(expression) \
 	do { \
 		if (!(expression)) { \
 			printk(KERN_ERR  FILE_LINE \
-				"ASSERT " __stringify(expression)); \
+				" ASSERT " __stringify(expression)); \
 		} \
 	} while (0)
 
@@ -46,7 +45,7 @@ enum { HPI_DEBUG_LEVEL_ERROR = 0,	/* alw
 	do { \
 		if (hpi_debug_level >= HPI_DEBUG_LEVEL_##level) { \
 			printk(HPI_DEBUG_FLAG_##level \
-			FILE_LINE  __VA_ARGS__); \
+			FILE_LINE " " __VA_ARGS__); \
 		} \
 	} while (0)
 
@@ -70,7 +69,7 @@ void hpi_debug_data(u16 *pdata, u32 len)
 	do { \
 		if (hpi_debug_level >= HPI_DEBUG_LEVEL_##level) { \
 			hpi_debug_message(phm, HPI_DEBUG_FLAG_##level \
-				FILE_LINE __stringify(level)); \
+				FILE_LINE " " __stringify(level)); \
 		} \
 	} while (0)
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are


