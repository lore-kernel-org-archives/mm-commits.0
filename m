From: akpm@linux-foundation.org
Subject: [merged] ocfs2-trusted-xattr-missing-cap_sys_admin-check.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:02:20 -0700
Message-ID: <55ef22ac.OI3iAz7rEJeEI9S8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbbIHSCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sanidhya.gatech@gmail.com, jlbec@evilplan.org, mfasheh@suse.de, taesoo@gatech.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: trusted xattr missing CAP_SYS_ADMIN check
has been removed from the -mm tree.  Its filename was
     ocfs2-trusted-xattr-missing-cap_sys_admin-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Subject: ocfs2: trusted xattr missing CAP_SYS_ADMIN check

The trusted extended attributes are only visible to the process which hvae
CAP_SYS_ADMIN capability but the check is missing in ocfs2 xattr_handler
trusted list.  The check is important because this will be used for
implementing mechanisms in the userspace for which other ordinary
processes should not have access to.

Signed-off-by: Sanidhya Kashyap <sanidhya.gatech@gmail.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Taesoo kim <taesoo@gatech.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/xattr.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ocfs2/xattr.c~ocfs2-trusted-xattr-missing-cap_sys_admin-check fs/ocfs2/xattr.c
--- a/fs/ocfs2/xattr.c~ocfs2-trusted-xattr-missing-cap_sys_admin-check
+++ a/fs/ocfs2/xattr.c
@@ -7334,6 +7334,9 @@ static size_t ocfs2_xattr_trusted_list(s
 	const size_t prefix_len = XATTR_TRUSTED_PREFIX_LEN;
 	const size_t total_len = prefix_len + name_len + 1;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return 0;
+
 	if (list && total_len <= list_size) {
 		memcpy(list, XATTR_TRUSTED_PREFIX, prefix_len);
 		memcpy(list + prefix_len, name, name_len);
_

Patches currently in -mm which might be from sanidhya.gatech@gmail.com are


