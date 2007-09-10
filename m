From: akpm@linux-foundation.org
Subject: + constify-string-array-kparam-tracking-structures.patch added to -mm tree
Date: Mon, 10 Sep 2007 01:52:24 -0700
Message-ID: <200709100852.l8A8qOEM016089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755927AbXIJIw1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 04:52:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com


The patch titled
     constify string/array kparam tracking structures
has been added to the -mm tree.  Its filename is
     constify-string-array-kparam-tracking-structures.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: constify string/array kparam tracking structures
From: "Jan Beulich" <jbeulich@novell.com>

.. in an effort to make read-only whatever can be made, so that
CONFIG_DEBUG_RODATA can catch as many issues as possible.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/moduleparam.h |   18 +++++++++++-------
 kernel/params.c             |   17 +++++++----------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff -puN include/linux/moduleparam.h~constify-string-array-kparam-tracking-structures include/linux/moduleparam.h
--- a/include/linux/moduleparam.h~constify-string-array-kparam-tracking-structures
+++ a/include/linux/moduleparam.h
@@ -38,7 +38,11 @@ struct kernel_param {
 	unsigned int perm;
 	param_set_fn set;
 	param_get_fn get;
-	void *arg;
+	union {
+		void *arg;
+		const struct kparam_string *str;
+		const struct kparam_array *arr;
+	};
 };
 
 /* Special one for strings we want to copy into */
@@ -66,11 +70,11 @@ struct kparam_array
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
-	static char __param_str_##name[] = prefix #name;		\
+	static const char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param const __param_##name			\
 	__attribute_used__						\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, perm, set, get, arg }
+	= { __param_str_##name, perm, set, get, { arg } }
 
 #define module_param_call(name, set, get, arg, perm)			      \
 	__module_param_call(MODULE_PARAM_PREFIX, name, set, get, arg, perm)
@@ -88,10 +92,10 @@ struct kparam_array
 
 /* Actually copy string: maxlen param is usually sizeof(string). */
 #define module_param_string(name, string, len, perm)			\
-	static struct kparam_string __param_string_##name		\
+	static const struct kparam_string __param_string_##name		\
 		= { len, string };					\
 	module_param_call(name, param_set_copystring, param_get_string,	\
-		   &__param_string_##name, perm);			\
+			  .str = &__param_string_##name, perm);		\
 	__MODULE_PARM_TYPE(name, "string")
 
 /* Called on module insert or kernel boot */
@@ -149,11 +153,11 @@ extern int param_get_invbool(char *buffe
 
 /* Comma-separated array: *nump is set to number they actually specified. */
 #define module_param_array_named(name, array, type, nump, perm)		\
-	static struct kparam_array __param_arr_##name			\
+	static const struct kparam_array __param_arr_##name		\
 	= { ARRAY_SIZE(array), nump, param_set_##type, param_get_##type,\
 	    sizeof(array[0]), array };					\
 	module_param_call(name, param_array_set, param_array_get, 	\
-			  &__param_arr_##name, perm);			\
+			  .arr = &__param_arr_##name, perm);		\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
 #define module_param_array(name, type, nump, perm)		\
diff -puN kernel/params.c~constify-string-array-kparam-tracking-structures kernel/params.c
--- a/kernel/params.c~constify-string-array-kparam-tracking-structures
+++ a/kernel/params.c
@@ -252,8 +252,9 @@ int param_get_bool(char *buffer, struct 
 int param_set_invbool(const char *val, struct kernel_param *kp)
 {
 	int boolval, ret;
-	struct kernel_param dummy = { .arg = &boolval };
+	struct kernel_param dummy;
 
+	dummy.arg = &boolval;
 	ret = param_set_bool(val, &dummy);
 	if (ret == 0)
 		*(int *)kp->arg = !boolval;
@@ -262,11 +263,7 @@ int param_set_invbool(const char *val, s
 
 int param_get_invbool(char *buffer, struct kernel_param *kp)
 {
-	int val;
-	struct kernel_param dummy = { .arg = &val };
-
-	val = !*(int *)kp->arg;
-	return param_get_bool(buffer, &dummy);
+	return sprintf(buffer, "%c", (*(int *)kp->arg) ? 'N' : 'Y');
 }
 
 /* We break the rule and mangle the string. */
@@ -325,7 +322,7 @@ static int param_array(const char *name,
 
 int param_array_set(const char *val, struct kernel_param *kp)
 {
-	struct kparam_array *arr = kp->arg;
+	const struct kparam_array *arr = kp->arr;
 	unsigned int temp_num;
 
 	return param_array(kp->name, val, 1, arr->max, arr->elem,
@@ -335,7 +332,7 @@ int param_array_set(const char *val, str
 int param_array_get(char *buffer, struct kernel_param *kp)
 {
 	int i, off, ret;
-	struct kparam_array *arr = kp->arg;
+	const struct kparam_array *arr = kp->arr;
 	struct kernel_param p;
 
 	p = *kp;
@@ -354,7 +351,7 @@ int param_array_get(char *buffer, struct
 
 int param_set_copystring(const char *val, struct kernel_param *kp)
 {
-	struct kparam_string *kps = kp->arg;
+	const struct kparam_string *kps = kp->str;
 
 	if (!val) {
 		printk(KERN_ERR "%s: missing param set value\n", kp->name);
@@ -371,7 +368,7 @@ int param_set_copystring(const char *val
 
 int param_get_string(char *buffer, struct kernel_param *kp)
 {
-	struct kparam_string *kps = kp->arg;
+	const struct kparam_string *kps = kp->str;
 	return strlcpy(buffer, kps->string, kps->maxlen);
 }
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

revert-x86_64-mm-intel_cacheinfo-adjustments.patch
fix-x86_64-mm-unwinder.patch
floppy-tolerate-dma-channel-unavailability.patch
cleanup-floppyh.patch
handle-recursive-calls-to-bust_spinlocks.patch
store-__setup_str_-in-a-more-compact-way.patch
constify-string-array-kparam-tracking-structures.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
