From: akpm@linux-foundation.org
Subject: [patch 091/126] lib/oid_registry.c: X.509: fix the buffer
 overflow in the utility function for OID string
Date: Fri, 08 Sep 2017 16:15:58 -0700
Message-ID: <20170908231558.8vAZQrmxG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753026AbdIHXP7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:15:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, jlee@suse.com, mm-commits@vger.kernel.org, pwieczorkiewicz@suse.com, rusty@rustcorp.com.au, tiwai@suse.de, torvalds@linux-foundation.org

From: Takashi Iwai <tiwai@suse.de>
Subject: lib/oid_registry.c: X.509: fix the buffer overflow in the utility function for OID string

The sprint_oid() utility function doesn't properly check the buffer size
that it causes that the warning in vsnprintf() be triggered.  For example
on v4.1 kernel:

[   49.612536] ------------[ cut here ]------------
[   49.612543] WARNING: CPU: 0 PID: 2357 at lib/vsprintf.c:1867 vsnprintf+0x5a7/0x5c0()
...

We can trigger this issue by injecting maliciously crafted x509 cert in
DER format.  Just using hex editor to change the length of OID to over the
length of the SEQUENCE container.  For example:

    0:d=0  hl=4 l= 980 cons: SEQUENCE
    4:d=1  hl=4 l= 700 cons:  SEQUENCE
    8:d=2  hl=2 l=   3 cons:   cont [ 0 ]
   10:d=3  hl=2 l=   1 prim:    INTEGER           :02
   13:d=2  hl=2 l=   9 prim:   INTEGER           :9B47FAF791E7D1E3
   24:d=2  hl=2 l=  13 cons:   SEQUENCE
   26:d=3  hl=2 l=   9 prim:    OBJECT            :sha256WithRSAEncryption
   37:d=3  hl=2 l=   0 prim:    NULL
   39:d=2  hl=2 l= 121 cons:   SEQUENCE
   41:d=3  hl=2 l=  22 cons:    SET
   43:d=4  hl=2 l=  20 cons:     SEQUENCE      <=== the SEQ length is 20
   45:d=5  hl=2 l=   3 prim:      OBJECT            :organizationName
	<=== the original length is 3, change the length of OID to over the length of SEQUENCE

Pawel Wieczorkiewicz reported this problem and Takashi Iwai provided patch
to fix it by checking the bufsize in sprint_oid().

Link: http://lkml.kernel.org/r/20170903021646.2080-1-jlee@suse.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
Reported-by: Pawel Wieczorkiewicz <pwieczorkiewicz@suse.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pawel Wieczorkiewicz <pwieczorkiewicz@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/oid_registry.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/oid_registry.c~x509-fix-the-buffer-overflow-in-the-utility-function-for-oid-string lib/oid_registry.c
--- a/lib/oid_registry.c~x509-fix-the-buffer-overflow-in-the-utility-function-for-oid-string
+++ a/lib/oid_registry.c
@@ -142,9 +142,9 @@ int sprint_oid(const void *data, size_t
 		}
 		ret += count = snprintf(buffer, bufsize, ".%lu", num);
 		buffer += count;
-		bufsize -= count;
-		if (bufsize == 0)
+		if (bufsize <= count)
 			return -ENOBUFS;
+		bufsize -= count;
 	}
 
 	return ret;
_
