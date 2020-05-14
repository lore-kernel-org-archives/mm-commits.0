From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 5/7] ipc/util.c: sysvipc_find_ipc() incorrectly
 updates position index
Date: Wed, 13 May 2020 17:50:48 -0700
Message-ID: <20200514005048.N5zHLNCxr%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbgENAut (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 May 2020 20:50:49 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, linux-mm@kvack.org, longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com, rostedt@goodmis.org, schwab@suse.de, stable@vger.kernel.org, torvalds@linux-foundation.org, vvs@virtuozzo.com

From: Vasily Averin <vvs@virtuozzo.com>
Subject: ipc/util.c: sysvipc_find_ipc() incorrectly updates position index

Commit 89163f93c6f9 ("ipc/util.c: sysvipc_find_ipc() should increase
position index") is causing this bug (seen on 5.6.8):

# ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages    

# ipcmk -Q
Message queue id: 0
# ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages    
0x82db8127 0          root       644        0            0           

# ipcmk -Q
Message queue id: 1
# ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages    
0x82db8127 0          root       644        0            0           
0x76d1fb2a 1          root       644        0            0           

# ipcrm -q 0
# ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages    
0x76d1fb2a 1          root       644        0            0           
0x76d1fb2a 1          root       644        0            0           

# ipcmk -Q
Message queue id: 2
# ipcrm -q 2
# ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages    
0x76d1fb2a 1          root       644        0            0           
0x76d1fb2a 1          root       644        0            0           

# ipcmk -Q
Message queue id: 3
# ipcrm -q 1
# ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages    
0x7c982867 3          root       644        0            0           
0x7c982867 3          root       644        0            0           
0x7c982867 3          root       644        0            0           
0x7c982867 3          root       644        0            0           


Whenever an IPC item with a low id is deleted, the items with higher ids
are duplicated, as if filling a hole.

new_pos should jump through hole of unused ids, pos can be updated inside
"for" cycle.

Link: http://lkml.kernel.org/r/4921fe9b-9385-a2b4-1dc4-1099be6d2e39@virtuozzo.com
Fixes: 89163f93c6f9 ("ipc/util.c: sysvipc_find_ipc() should increase position index")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reported-by: Andreas Schwab <schwab@suse.de>
Acked-by: Waiman Long <longman@redhat.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/ipc/util.c~ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index
+++ a/ipc/util.c
@@ -764,21 +764,21 @@ static struct kern_ipc_perm *sysvipc_fin
 			total++;
 	}
 
-	*new_pos = pos + 1;
+	ipc = NULL;
 	if (total >= ids->in_use)
-		return NULL;
+		goto out;
 
 	for (; pos < ipc_mni; pos++) {
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			rcu_read_lock();
 			ipc_lock_object(ipc);
-			return ipc;
+			break;
 		}
 	}
