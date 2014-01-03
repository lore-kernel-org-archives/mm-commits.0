From: akpm@linux-foundation.org
Subject: +
 documentation-misc-devices-mei-mei-amt-versionc-remove-unneeded-call-of-mei_deinit.patch added to -mm tree
Date: Fri, 03 Jan 2014 14:44:19 -0800
Message-ID: <52c73d43.xfiDiEY/6jPhM15B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51348 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaACWoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jan 2014 17:44:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomas.winkler@intel.com, gregkh@linuxfoundation.org, dhowells@redhat.com, pebolle@tiscali.nl

Subject: + documentation-misc-devices-mei-mei-amt-versionc-remove-unneeded-call-of-mei_deinit.patch added to -mm tree
To: pebolle@tiscali.nl,dhowells@redhat.com,gregkh@linuxfoundation.org,tomas.winkler@intel.com
From: akpm@linux-foundation.org
Date: Fri, 03 Jan 2014 14:44:19 -0800


The patch titled
     Subject: Documentation/misc-devices/mei/mei-amt-version.c: remove unneeded call of mei_deinit()
has been added to the -mm tree.  Its filename is
     documentation-misc-devices-mei-mei-amt-versionc-remove-unneeded-call-of-mei_deinit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-misc-devices-mei-mei-amt-versionc-remove-unneeded-call-of-mei_deinit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-misc-devices-mei-mei-amt-versionc-remove-unneeded-call-of-mei_deinit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: Documentation/misc-devices/mei/mei-amt-version.c: remove unneeded call of mei_deinit()

Building mei-amt-version.o triggers a GCC warning:
    Documentation/misc-devices/mei/mei-amt-version.c: In function 'main':
    Documentation/misc-devices/mei/mei-amt-version.c:103:5: warning: 'acmd.fd' is used uninitialized in this function [-Wuninitialized]
      if (cl->fd != -1)
         ^
    Documentation/misc-devices/mei/mei-amt-version.c:443:21: note: 'acmd.fd' was declared here
      struct amt_host_if acmd;
                         ^

GCC is correct. See, the call chain that GCC detects must be
    main()
        amt_host_if_init()
            mei_init()
                mei_deinit()

But when we enter mei_deinit() struct amt_host_if acmd is still
unitialized. That makes the test for (effectively) amt_host_if->mei_cl->fd
bogus.

But it turns out that call of mei_deinit() isn't needed at all. All of
the members of mei_cl will be set later in mei_init() and none will be
used before they are set. So we can simply drop this call of
mei_deinit().

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Reported-by: David Howells <dhowells@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/misc-devices/mei/mei-amt-version.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN Documentation/misc-devices/mei/mei-amt-version.c~documentation-misc-devices-mei-mei-amt-versionc-remove-unneeded-call-of-mei_deinit Documentation/misc-devices/mei/mei-amt-version.c
--- a/Documentation/misc-devices/mei/mei-amt-version.c~documentation-misc-devices-mei-mei-amt-versionc-remove-unneeded-call-of-mei_deinit
+++ a/Documentation/misc-devices/mei/mei-amt-version.c
@@ -115,8 +115,6 @@ static bool mei_init(struct mei *me, con
 	struct mei_client *cl;
 	struct mei_connect_client_data data;
 
-	mei_deinit(me);
