From: akpm@linux-foundation.org
Subject: - audit-fix-nul-handling-in-untrusted-strings.patch removed from -mm tree
Date: Thu, 11 Sep 2008 15:33:28 -0700
Message-ID: <200809112233.m8BMXSff019905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbYIKWdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Sep 2008 18:33:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mitr@redhat.com, eparis@redhat.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: fix NUL handling in untrusted strings
has been removed from the -mm tree.  Its filename was
     audit-fix-nul-handling-in-untrusted-strings.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: fix NUL handling in untrusted strings
From: Miloslav Trmac <mitr@redhat.com>

audit_string_contains_control() stops checking at the first NUL byte.  If
audit_string_contains_control() returns FALSE,
audit_log_n_untrustedstring() submits the complete string - including the
NUL byte and all following bytes, up to the specified maximum length - to
audit_log_n_string(), which copies the data unchanged into the audit
record.

The audit record can thus contain a NUL byte (and some unchecked data
after that).  Because the user-space audit daemon treats audit records as
NUL-terminated strings, an untrusted string that is shorter than the
specified maximum length effectively terminates the audit record.

This patch modifies audit_log_n_untrustedstring() to only log the data
before the first NUL byte, if any.

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff -puN kernel/audit.c~audit-fix-nul-handling-in-untrusted-strings kernel/audit.c
--- a/kernel/audit.c~audit-fix-nul-handling-in-untrusted-strings
+++ a/kernel/audit.c
@@ -1362,6 +1362,12 @@ void audit_log_n_string(struct audit_buf
 	skb_put(skb, slen + 2);	/* don't include null terminator */
 }
 
+static inline int
+audit_is_control_character(unsigned char c)
+{
+	return c == '"' || c < 0x21 || c > 0x7E;
+}
+
 /**
  * audit_string_contains_control - does a string need to be logged in hex
  * @string: string to be checked
@@ -1371,7 +1377,7 @@ int audit_string_contains_control(const 
 {
 	const unsigned char *p;
 	for (p = string; p < (const unsigned char *)string + len && *p; p++) {
-		if (*p == '"' || *p < 0x21 || *p > 0x7e)
+		if (audit_is_control_character(*p))
 			return 1;
 	}
 	return 0;
@@ -1394,10 +1400,15 @@ int audit_string_contains_control(const 
 void audit_log_n_untrustedstring(struct audit_buffer *ab, const char *string,
 				 size_t len)
 {
-	if (audit_string_contains_control(string, len))
-		audit_log_n_hex(ab, string, len);
-	else
-		audit_log_n_string(ab, string, len);
+	const unsigned char *p;
+
+	for (p = string; p < (const unsigned char *)string + len && *p; p++) {
+		if (audit_is_control_character(*p)) {
+			audit_log_n_hex(ab, string, len);
+			return;
+		}
+	}
+	audit_log_n_string(ab, string, p - (const unsigned char *)string);
 }
 
 /**
_

Patches currently in -mm which might be from mitr@redhat.com are

audit-fix-nul-handling-in-untrusted-strings.patch
audit-handle-embedded-nul-in-tty-input-auditing.patch

