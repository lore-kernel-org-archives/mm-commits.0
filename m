Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEDFC54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 19:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiH2T4W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 15:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiH2T4I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 15:56:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75D413D6D
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 12:56:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D0B760F1E
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 19:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B418C433D7;
        Mon, 29 Aug 2022 19:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661802964;
        bh=1/Dpvu90iZKtSWP9Co17TZ+2MPQFxEwH4fPGxer/nOc=;
        h=Date:To:From:Subject:From;
        b=lWdrJj59gHTNhbkwkJrXHkDjeLq/G/abIVRLq9baxW0karRl6GxuCleEM1TDfcF36
         LpaowI0t9AQWfnQdsmKctVjt/S1T8qUUbPp7CtwVaK8puR1yKVvExIJYCnHmYVFjKs
         6kNhVZWhNLMosf/kC+OiubB0U4g4Wu8OOiliITvo=
Date:   Mon, 29 Aug 2022 12:56:03 -0700
To:     mm-commits@vger.kernel.org, yury.norov@gmail.com, vbabka@suse.cz,
        sander@svanheule.net, rostedt@goodmis.org, peterz@infradead.org,
        nathan@kernel.org, mingo@redhat.com, mhiramat@kernel.org,
        luc.vanoostenryck@gmail.com, linux@rasmusvillemoes.dk,
        jpoimboe@kernel.org, Jason@zx2c4.com, isabbasso@riseup.net,
        edumazet@google.com, dan.j.williams@intel.com, arnd@arndb.de,
        bvanassche@acm.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] overflow-tracing-define-the-is_signed_type-macro-once.patch removed from -mm tree
Message-Id: <20220829195604.9B418C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: overflow, tracing: define the is_signed_type() macro once
has been removed from the -mm tree.  Its filename was
     overflow-tracing-define-the-is_signed_type-macro-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bart Van Assche <bvanassche@acm.org>
Subject: overflow, tracing: define the is_signed_type() macro once
Date: Fri, 26 Aug 2022 09:21:16 -0700

There are two definitions of the is_signed_type() macro: one in
<linux/overflow.h> and a second definition in <linux/trace_events.h>.

As suggested by Linus Torvalds, move the definition of the
is_signed_type() macro into the <linux/compiler.h> header file.  Change
the definition of the is_signed_type() macro to make sure that it does not
trigger any sparse warnings with future versions of sparse for bitwise
types.  See also:

https://lore.kernel.org/all/CAHk-=whjH6p+qzwUdx5SOVVHjS3WvzJQr6mDUwhEyTf6pJWzaQ@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wjQGnVfb4jehFR0XyZikdQvCZouE96xR_nnf5kqaM5qqQ@mail.gmail.com/

Link: https://lkml.kernel.org/r/20220826162116.1050972-3-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Isabella Basso <isabbasso@riseup.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sander Vanheule <sander@svanheule.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h     |    6 ++++++
 include/linux/overflow.h     |    1 -
 include/linux/trace_events.h |    2 --
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/compiler.h~overflow-tracing-define-the-is_signed_type-macro-once
+++ a/include/linux/compiler.h
@@ -240,6 +240,12 @@ static inline void *offset_to_ptr(const
 #define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 
 /*
+ * Whether 'type' is a signed type or an unsigned type. Supports scalar types,
+ * bool and also pointer types.
+ */
+#define is_signed_type(type) (((type)(-1)) < (__force type)1)
+
+/*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
  */
--- a/include/linux/overflow.h~overflow-tracing-define-the-is_signed_type-macro-once
+++ a/include/linux/overflow.h
@@ -30,7 +30,6 @@
  * https://mail-index.netbsd.org/tech-misc/2007/02/05/0000.html -
  * credit to Christian Biere.
  */
-#define is_signed_type(type)       (((type)(-1)) < (type)1)
 #define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 - is_signed_type(type)))
 #define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
 #define type_min(T) ((T)((T)-type_max(T)-(T)1))
--- a/include/linux/trace_events.h~overflow-tracing-define-the-is_signed_type-macro-once
+++ a/include/linux/trace_events.h
@@ -814,8 +814,6 @@ extern int trace_add_event_call(struct t
 extern int trace_remove_event_call(struct trace_event_call *call);
 extern int trace_event_get_offsets(struct trace_event_call *call);
 
-#define is_signed_type(type)	(((type)(-1)) < (type)1)
-
 int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set);
 int trace_set_clr_event(const char *system, const char *event, int set);
 int trace_array_set_clr_event(struct trace_array *tr, const char *system,
_

Patches currently in -mm which might be from bvanassche@acm.org are

testing-selftests-add-tests-for-the-is_signed_type-macro.patch

