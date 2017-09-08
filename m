From: akpm@linux-foundation.org
Subject: [patch 124/126] ipc/sem: drop sem_checkid helper
Date: Fri, 08 Sep 2017 16:17:49 -0700
Message-ID: <20170908231749.7dBB0fuLD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757274AbdIHXRu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:17:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: drop sem_checkid helper

... 'tis not used.

Link: http://lkml.kernel.org/r/20170803184136.13855-1-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN ipc/sem.c~ipc-sem-drop-sem_checkid-helper ipc/sem.c
--- a/ipc/sem.c~ipc-sem-drop-sem_checkid-helper
+++ a/ipc/sem.c
@@ -130,8 +130,6 @@ struct sem_undo_list {
 
 #define sem_ids(ns)	((ns)->ids[IPC_SEM_IDS])
 
-#define sem_checkid(sma, semid)	ipc_checkid(&sma->sem_perm, semid)
