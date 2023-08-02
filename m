Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C55C001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 19:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbjHBTeT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjHBTeO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 15:34:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643B21990
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 12:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED22F61AF2
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 19:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF62C433C8;
        Wed,  2 Aug 2023 19:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691004852;
        bh=aqL0OagmcLSx7QoOAV+Z+QJobtjQaRgn9JsbI0z4Eak=;
        h=Date:To:From:Subject:From;
        b=zrTSRwRSAzVR60hGqZLxy3YaQGVgDMzO/7VaiqETHz7fSxOt/xv6Z14TM7XnXoHbc
         kqbQ9jG7PlcdlZCF2QqonsA53t9jN0hB4A1PhE27c0rtMAsb0w46X/Os+U6AvemPdJ
         CbTDXnuAe5gVV/3RPX4Yy3jYw2D+zCoN9Co6Lb/A=
Date:   Wed, 02 Aug 2023 12:34:11 -0700
To:     mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com,
        junxiao.bi@oracle.com, jlbec@evilplan.org, jiangqi903@gmail.com,
        ghe@suse.com, dg573847474@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cluster-fix-potential-deadlock-on-o2net_debug_lock.patch added to mm-nonmm-unstable branch
Message-Id: <20230802193412.4BF62C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: cluster: fix potential deadlock on &o2net_debug_lock
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-cluster-fix-potential-deadlock-on-o2net_debug_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cluster-fix-potential-deadlock-on-o2net_debug_lock.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Chengfeng Ye <dg573847474@gmail.com>
Subject: ocfs2: cluster: fix potential deadlock on &o2net_debug_lock
Date: Wed, 2 Aug 2023 13:14:36 +0000

&o2net_debug_lock is acquired by timer o2net_idle_timer() along the
following call chain.  Thus the acquisition of the lock under process
context should disable bottom half, otherwise deadlock could happen if the
timer happens to preempt the execution while the lock is held in process
context on the same CPU.

<timer interrupt>
        -> o2net_idle_timer()
        -> queue_delayed_work()
        -> sc_put()
        -> sc_kref_release()
        -> o2net_debug_del_sc()
        -> spin_lock(&o2net_debug_lock);

Several lock acquisition of &o2net_debug_lock under process context do not
disable irq or bottom half.  The patch fixes these potential deadlocks
scenerio by using spin_lock_bh() on &o2net_debug_lock.

This flaw was found by an experimental static analysis tool I am
developing for irq-related deadlock.  x86_64 allmodconfig using gcc shows
no new warning.

Link: https://lkml.kernel.org/r/20230802131436.17765-1-dg573847474@gmail.com
Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/netdebug.c |   40 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/fs/ocfs2/cluster/netdebug.c~ocfs2-cluster-fix-potential-deadlock-on-o2net_debug_lock
+++ a/fs/ocfs2/cluster/netdebug.c
@@ -44,17 +44,17 @@ static LIST_HEAD(send_tracking);
 
 void o2net_debug_add_nst(struct o2net_send_tracking *nst)
 {
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	list_add(&nst->st_net_debug_item, &send_tracking);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 }
 
 void o2net_debug_del_nst(struct o2net_send_tracking *nst)
 {
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	if (!list_empty(&nst->st_net_debug_item))
 		list_del_init(&nst->st_net_debug_item);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 }
 
 static struct o2net_send_tracking
@@ -84,9 +84,9 @@ static void *nst_seq_start(struct seq_fi
 {
 	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	nst = next_nst(dummy_nst);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return nst;
 }
@@ -95,13 +95,13 @@ static void *nst_seq_next(struct seq_fil
 {
 	struct o2net_send_tracking *nst, *dummy_nst = seq->private;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	nst = next_nst(dummy_nst);
 	list_del_init(&dummy_nst->st_net_debug_item);
 	if (nst)
 		list_add(&dummy_nst->st_net_debug_item,
 			 &nst->st_net_debug_item);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return nst; /* unused, just needs to be null when done */
 }
@@ -112,7 +112,7 @@ static int nst_seq_show(struct seq_file
 	ktime_t now;
 	s64 sock, send, status;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	nst = next_nst(dummy_nst);
 	if (!nst)
 		goto out;
@@ -145,7 +145,7 @@ static int nst_seq_show(struct seq_file
 		   (long long)status);
 
 out:
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return 0;
 }
@@ -191,16 +191,16 @@ static const struct file_operations nst_
 
 void o2net_debug_add_sc(struct o2net_sock_container *sc)
 {
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	list_add(&sc->sc_net_debug_item, &sock_containers);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 }
 
 void o2net_debug_del_sc(struct o2net_sock_container *sc)
 {
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	list_del_init(&sc->sc_net_debug_item);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 }
 
 struct o2net_sock_debug {
@@ -236,9 +236,9 @@ static void *sc_seq_start(struct seq_fil
 	struct o2net_sock_debug *sd = seq->private;
 	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	sc = next_sc(dummy_sc);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return sc;
 }
@@ -248,12 +248,12 @@ static void *sc_seq_next(struct seq_file
 	struct o2net_sock_debug *sd = seq->private;
 	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	sc = next_sc(dummy_sc);
 	list_del_init(&dummy_sc->sc_net_debug_item);
 	if (sc)
 		list_add(&dummy_sc->sc_net_debug_item, &sc->sc_net_debug_item);
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return sc; /* unused, just needs to be null when done */
 }
@@ -349,7 +349,7 @@ static int sc_seq_show(struct seq_file *
 	struct o2net_sock_debug *sd = seq->private;
 	struct o2net_sock_container *sc, *dummy_sc = sd->dbg_sock;
 
-	spin_lock(&o2net_debug_lock);
+	spin_lock_bh(&o2net_debug_lock);
 	sc = next_sc(dummy_sc);
 
 	if (sc) {
@@ -359,7 +359,7 @@ static int sc_seq_show(struct seq_file *
 			sc_show_sock_stats(seq, sc);
 	}
 
-	spin_unlock(&o2net_debug_lock);
+	spin_unlock_bh(&o2net_debug_lock);
 
 	return 0;
 }
_

Patches currently in -mm which might be from dg573847474@gmail.com are

ocfs2-cluster-fix-potential-deadlock-on-qs-qs_lock.patch
ocfs2-cluster-fix-potential-deadlock-on-o2net_debug_lock.patch

